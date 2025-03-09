# modules/postgres/outputs.tf

output "postgres_instance_name" {
  description = "Nombre de la instancia de PostgreSQL"
  value       = google_sql_database_instance.postgres.name
}

output "postgres_instance_connection_name" {
  description = "Nombre de conexión de la instancia de PostgreSQL"
  value       = google_sql_database_instance.postgres.connection_name
}

output "postgres_instance_private_ip" {
  description = "Dirección IP privada de la instancia de PostgreSQL"
  value       = google_sql_database_instance.postgres.private_ip_address
}

output "postgres_database_name" {
  description = "Nombre de la base de datos PostgreSQL"
  value       = google_sql_database.database.name
}