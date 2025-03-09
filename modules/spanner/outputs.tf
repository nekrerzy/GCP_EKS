# modules/spanner/outputs.tf

output "enabled" {
  description = "Indica si Spanner está habilitado"
  value       = var.enabled
}

output "instance_name" {
  description = "Nombre de la instancia de Spanner"
  value       = var.enabled ? google_spanner_instance.instance[0].name : ""
}

output "instance_display_name" {
  description = "Nombre descriptivo de la instancia de Spanner"
  value       = var.enabled ? google_spanner_instance.instance[0].display_name : ""
}

output "database_name" {
  description = "Nombre de la base de datos Spanner"
  value       = var.enabled ? google_spanner_database.database[0].name : ""
}

output "spanner_uri" {
  description = "URI para la conexión a Spanner"
  value       = var.enabled ? "projects/${var.project_id}/instances/${google_spanner_instance.instance[0].name}/databases/${google_spanner_database.database[0].name}" : ""
}