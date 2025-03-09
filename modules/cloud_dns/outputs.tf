# modules/cloud_dns/outputs.tf

output "dns_zone_name" {
  description = "Nombre de la zona DNS administrada"
  value       = google_dns_managed_zone.private_zone.name
}

output "dns_name_servers" {
  description = "Servidores de nombres para la zona DNS"
  value       = google_dns_managed_zone.private_zone.name_servers
}

output "postgres_fqdn" {
  description = "Nombre de dominio completo para PostgreSQL"
  value       = google_dns_record_set.postgres.name
}

output "vertex_fqdn" {
  description = "Nombre de dominio completo para Vertex AI"
  value       = google_dns_record_set.vertex.name
}

output "artifacts_fqdn" {
  description = "Nombre de dominio completo para Artifact Registry"
  value       = google_dns_record_set.artifacts.name
}

output "app_fqdn" {
  description = "Nombre de dominio completo para la aplicación"
  value       = var.app_ip != "" ? google_dns_record_set.app[0].name : null
}


output "redis_fqdn" {
  description = "Nombre de dominio completo para Redis"
  value       = var.redis_host != "" ? google_dns_record_set.redis.name : null
}


output "spanner_fqdn" {
  description = "Nombre de dominio completo para Spanner"
  value       = var.spanner_enabled && var.spanner_instance != "" ? google_dns_record_set.spanner[0].name : null
}