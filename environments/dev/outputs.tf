
#CLOND DNS SECTION

output "dns_zone_name" {
  description = "Nombre de la zona DNS administrada"
  value       = module.cloud_dns.dns_zone_name
}

output "postgres_fqdn" {
  description = "Nombre de dominio completo para PostgreSQL"
  value       = module.cloud_dns.postgres_fqdn
  
}

output "vertex_fqdn" {
  description = "Nombre de dominio completo para Vertex AI"
  value       = module.cloud_dns.vertex_fqdn
  
}

output "artifacts_fqdn" {
  description = "Nombre de dominio completo para Artifact Registry"
  value       = module.cloud_dns.artifacts_fqdn
  
}

output "redis_fqdn" {
  description = "Nombre de dominio completo para Redis"
  value       = module.cloud_dns.redis_fqdn
  
}

output "spanner_fqdn" {
  description = "Nombre de dominio completo para Spanner"
  value       = module.cloud_dns.spanner_fqdn
  
}

#GKE SECTION

output "cluster_name" {
  description = "Nombre del clúster de GKE"
  value       = module.gke.cluster_name
}

output "cluster_endpoint" {
  description = "Punto final del clúster de GKE"
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

#POSTGRES SECTION

output "postgres_instance_name" {
  description = "Nombre de la instancia de PostgreSQL"
  value       = module.postgres.postgres_instance_name
}

output "postgres_database_name" {
  description = "Nombre de la base de datos PostgreSQL"
  value       = module.postgres.postgres_database_name
  
}

#REDIS SECTION

output "redis_name" {
  description = "Nombre de la instancia de Redis"
  value       = module.redis.redis_name
  
}

output "redis_memory_size_gb" {
  description = "Tamaño de memoria en GB de la instancia de Redis"
  value       = module.redis.redis_memory_size_gb
  
}

output "redis_auth_string" {
  description = "Token de autenticación de la instancia de Redis"
  value       = module.redis.redis_auth_string
  sensitive = true
  
}

#SPANNER SECTION

output "spanner_enabled" {
  description = "Indica si Spanner está habilitado"
  value       = module.spanner.enabled
  
}

output "spanner_instance_name" {
  description = "Nombre de la instancia de Spanner"
  value       = module.spanner.instance_name
  
}

output "spanner_instance_display_name" {
  description = "Nombre descriptivo de la instancia de Spanner"
  value       = module.spanner.instance_display_name
  
}

output "spanner_database_name" {
  description = "Nombre de la base de datos Spanner"
  value       = module.spanner.database_name
  
}

output "spanner_uri" {
  description = "URI para la conexión a Spanner"
  value       = module.spanner.spanner_uri
  
}

#storage SECTION

output "vertex_bucket_name" {
  description = "Nombre del bucket de Cloud Storage"
  value       = module.storage.vertex_bucket_name
  
}

output "vertex_bucket_url" {
  description = "URL del bucket de Cloud Storage"
  value       = module.storage.vertex_bucket_url
  
}

output "app_bucket_name" {
  description = "Nombre del bucket de Cloud Storage"
  value       = module.storage.app_bucket_name
  
}

output "app_bucket_url" {
  description = "URL del bucket de Cloud Storage"
  value       = module.storage.app_bucket_url
  
}


