# environments/dev/main.tf

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = var.credentials
}

provider "kubernetes" {
  host                   = "https://${module.gke.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = module.gke.cluster_ca_certificate
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "true" # A simple command that always passes
    args        = ["ignore this"]
  }
}

data "google_client_config" "default" {}

# First, enable all required APIs
module "api_enablement" {
  source     = "../../modules/api_enablement"
  project_id = var.project_id
}

module "networking" {
  source = "../../modules/networking"
  
  project_id   = var.project_id
  env          = "dev"
  region       = var.region
  subnet_cidr  = var.subnet_cidr
  pod_cidr     = var.pod_cidr
  service_cidr = var.service_cidr
  
  depends_on = [module.api_enablement]
}

module "gke" {
  source = "../../modules/gke"
  
  project_id            = var.project_id
  env                   = "dev"
  region                = var.region
  vpc_name              = module.networking.vpc_name
  subnet_name           = module.networking.subnet_name
  node_count            = 1
  regional_cluster      = false
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  cluster_deletion_protection = var.cluster_deletion_protection

  depends_on = [module.networking]
}

module "postgres" {
  source = "../../modules/postgres"
  
  project_id                = var.project_id
  env                       = "dev"
  region                    = var.region
  vpc_id                    = module.networking.vpc_id
  private_vpc_connection_id = module.networking.private_vpc_connection
  db_name                   = var.db_name
  db_user                   = var.db_user
  db_password               = var.db_password

  depends_on = [module.networking]
}

module "spanner" {
  source = "../../modules/spanner"
  
  enabled = var.enable_spanner
  project_id = var.project_id
  env        = "dev"
  region     = var.region
  db_name    = var.spanner_db_name
}

module "artifact_registry" {
  source = "../../modules/artifact_registry"
  
  project_id = var.project_id
  env        = "dev"
  region     = var.region
}

module "storage" {
  source = "../../modules/storage"
  
  project_id = var.project_id
  env        = "dev"
  region     = var.region
}

module "vertex_ai" {
  source = "../../modules/vertex_ai"
  
  project_id = var.project_id
  env        = "dev"
  region     = var.region
  storage_bucket_name = module.storage.vertex_bucket_name
}

module "redis" {
  source = "../../modules/redis"
  
  project_id            = var.project_id
  env                   = "dev"
  region                = var.region
  vpc_id                = module.networking.vpc_id
  service_account_email = google_service_account.app_service_account.email
  
  
  # Configuración específica para desarrollo
  dev_memory_size_gb    = 1  # Mínimo tamaño para desarrollo
  redis_version         = "REDIS_7_0"
  
  depends_on = [
    module.networking,
    google_service_account.app_service_account
  ]
}


module "cloud_dns" {
  source = "../../modules/cloud_dns"
  redis_host      = module.redis.redis_host
  project_id      = var.project_id
  env             = "dev"
  region          = var.region
  vpc_id          = module.networking.vpc_id
  dns_base_name   = "internal.${var.project_id}.app"
  postgres_ip     = module.postgres.postgres_instance_private_ip
  spanner_instance = module.spanner.instance_name
  
  # La IP de la aplicación se puede añadir después del despliegue inicial
  # app_ip         = var.app_ip
  
  depends_on = [
    module.networking,
    module.postgres,
    module.spanner,
    module.redis
  ]
}

# Create a Kubernetes service account for workload identity
resource "kubernetes_service_account" "app_ksa" {
  metadata {
    name      = "app-ksa"
    namespace = "default"
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.app_service_account.email
    }
  }
  
  depends_on = [module.gke]
}

# Create a GCP service account for the application
resource "google_service_account" "app_service_account" {
  account_id   = "app-dev-sa"
  display_name = "Application Service Account (Dev)"
}

# IAM binding for workload identity
resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.app_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[default/app-ksa]"
  ]
}

# Grant permissions to the service account
resource "google_project_iam_member" "storage_permissions" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.app_service_account.email}"
}

resource "google_project_iam_member" "spanner_permissions" {
  project = var.project_id
  role    = "roles/spanner.admin"
  member  = "serviceAccount:${google_service_account.app_service_account.email}"
}

resource "google_project_iam_member" "redis_permissions" {
  project = var.project_id
  role    = "roles/redis.admin"
  member  = "serviceAccount:${google_service_account.app_service_account.email}"
}