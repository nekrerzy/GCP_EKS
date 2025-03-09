# modules/storage/outputs.tf

output "vertex_bucket_name" {
  description = "Vertex AI bucket name"
  value       = google_storage_bucket.vertex_bucket.name
}

output "vertex_bucket_url" {
  description = "Vertex AI bucket URL"
  value       = google_storage_bucket.vertex_bucket.url
}

output "app_bucket_name" {
  description = "Application bucket name"
  value       = google_storage_bucket.app_bucket.name
}

output "app_bucket_url" {
  description = "Application bucket URL"
  value       = google_storage_bucket.app_bucket.url
}