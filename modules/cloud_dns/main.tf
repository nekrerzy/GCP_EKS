# modules/cloud_dns/main.tf

# Zona DNS privada para servicios internos
resource "google_dns_managed_zone" "private_zone" {
  name        = "${var.project_id}-${var.env}-internal-dns"
  dns_name    = "${var.dns_base_name}."
  description = "Zona DNS privada para servicios internos (${var.env})"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = var.vpc_id
    }
  }
}

# Registro DNS para PostgreSQL
resource "google_dns_record_set" "postgres" {
  name         = "postgres.${var.dns_base_name}."
  managed_zone = google_dns_managed_zone.private_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [var.postgres_ip]
}

# Registro DNS para Spanner
resource "google_dns_record_set" "spanner" {
  count        = var.spanner_enabled && var.spanner_instance != "" ? 1 : 0
  name         = "spanner.${var.dns_base_name}."
  managed_zone = google_dns_managed_zone.private_zone.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["${var.spanner_instance}.googleapis.com."]
}

# Registro DNS para la aplicación (LoadBalancer)
resource "google_dns_record_set" "app" {
  count        = var.app_ip != "" ? 1 : 0
  name         = "app.${var.dns_base_name}."
  managed_zone = google_dns_managed_zone.private_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [var.app_ip]
}

# Registro DNS para Vertex AI
resource "google_dns_record_set" "vertex" {
  name         = "vertex.${var.dns_base_name}."
  managed_zone = google_dns_managed_zone.private_zone.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["${var.region}-aiplatform.googleapis.com."]
}

# Registro DNS para Artifact Registry
resource "google_dns_record_set" "artifacts" {
  name         = "artifacts.${var.dns_base_name}."
  managed_zone = google_dns_managed_zone.private_zone.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["${var.region}-docker.pkg.dev."]
}

# Registro DNS para Redis
resource "google_dns_record_set" "redis" {
  #count        = var.redis_host != "" ? 1 : 0
  name         = "redis.${var.dns_base_name}."
  managed_zone = google_dns_managed_zone.private_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [var.redis_host]
}