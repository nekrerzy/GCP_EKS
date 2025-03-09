# modules/redis/outputs.tf

output "redis_host" {
  description = "Hostname de la instancia de Redis"
  value       = google_redis_instance.cache.host
}

output "redis_port" {
  description = "Puerto de la instancia de Redis"
  value       = google_redis_instance.cache.port
}

output "redis_name" {
  description = "Nombre de la instancia de Redis"
  value       = google_redis_instance.cache.name
}

output "redis_memory_size_gb" {
  description = "Tamaño de memoria en GB de la instancia de Redis"
  value       = google_redis_instance.cache.memory_size_gb
}

output "redis_current_location_id" {
  description = "Ubicación actual de la instancia de Redis"
  value       = google_redis_instance.cache.current_location_id
}

output "redis_auth_string" {
  description = "Token de autenticación de la instancia de Redis"
  value       = google_redis_instance.cache.auth_string
  sensitive = true
  
}