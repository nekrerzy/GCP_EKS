# modules/vertex_ai/outputs.tf

output "service_account_email" {
  description = "Vertex AI Service Account Email"
  value       = google_service_account.vertex_ai_sa.email
}