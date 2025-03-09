# modules/artifact_registry/outputs.tf

output "repository_id" {
  description = "Docker repository ID"
  value       = google_artifact_registry_repository.docker_repo.repository_id
}

output "repository_url" {
  description = "Docker repository URL"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_repo.repository_id}"
}