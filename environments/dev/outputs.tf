# Output de Cloud DNS
output "dns_zone_name" {
  description = "Nombre de la zona DNS administrada"
  value       = module.cloud_dns.dns_zone_name
}

output "postgres_dns" {
  description = "Nombre DNS para PostgreSQL"
  value       = module.cloud_dns.postgres_fqdn
}

output "spanner_dns" {
  description = "Nombre DNS para Spanner"
  value       = module.cloud_dns.spanner_fqdn
}

output "vertex_dns" {
  description = "Nombre DNS para Vertex AI"
  value       = module.cloud_dns.vertex_fqdn
}

output "artifacts_dns" {
  description = "Nombre DNS para Artifact Registry"
  value       = module.cloud_dns.artifacts_fqdn
}



# Añade outputs para Redis
output "redis_host" {
  description = "Host de la instancia Redis"
  value       = module.redis.redis_host
}

output "redis_port" {
  description = "Puerto de la instancia Redis"
  value       = module.redis.redis_port
}

output "redis_dns" {
  description = "Nombre DNS para Redis"
  value       = module.cloud_dns.redis_fqdn
}


output "redis_auth_string" {
  description = "Token de autenticación de Redis"
  value       = module.redis.redis_auth_string
  sensitive   = true
}