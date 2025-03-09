# modules/redis/main.tf

# Habilitar la API de Redis
resource "google_project_service" "redis_api" {
  service = "redis.googleapis.com"
  disable_on_destroy = false
}

# Instancia de Redis
resource "google_redis_instance" "cache" {
  name           = "${var.project_id}-${var.env}-redis"
  display_name   = "Redis Cache for ${var.env}"
  tier           = var.env == "prod" ? "STANDARD_HA" : "BASIC"
  memory_size_gb = var.env == "prod" ? var.prod_memory_size_gb : var.dev_memory_size_gb
  
  region        = var.region
  location_id   = var.env == "prod" ? "us-central1-a" : "us-central1-a"
  
  redis_version = var.redis_version
  
  # Configuración de replicas para producción
  replica_count = var.env == "prod" ? var.replica_count : null
  
  # Configuración de autorización
  auth_enabled = true
  
  # Configuración de red privada
  authorized_network = var.vpc_id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  
  depends_on = [google_project_service.redis_api]
  
  # Para entorno de desarrollo, no usamos todas las características
  redis_configs = var.env == "prod" ? {
    "maxmemory-policy" = "allkeys-lru"
    "notify-keyspace-events" = "KEA"
  } : {
    "maxmemory-policy" = "allkeys-lru"
  }
}

# Configuración de IAM para permitir que la cuenta de servicio acceda a Redis
resource "google_project_iam_member" "redis_access" {
  project = var.project_id
  role    = "roles/redis.admin"
  member  = "serviceAccount:${var.service_account_email}"
  
  depends_on = [google_redis_instance.cache]
}