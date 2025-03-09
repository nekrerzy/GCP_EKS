# modules/api_enablement/outputs.tf

output "enabled_apis" {
  description = "Map of enabled APIs"
  value       = { for k, v in google_project_service.apis : k => v.service }
}