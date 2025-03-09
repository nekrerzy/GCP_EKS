# modules/artifact_registry/main.tf

# Artifact Registry for Docker images
resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "${var.project_id}-${var.env}-docker-repo"
  format        = "DOCKER"
  description   = "Docker repository for ${var.env} environment"
  
  # Add more advanced configuration for production
  dynamic "cleanup_policies" {
    for_each = var.env == "prod" ? [1] : []
    content {
      id     = "keep-recent-versions"
      action = "KEEP"
      condition {
        tag_state    = "TAGGED"
        tag_prefixes = ["release", "stable"]
      }
    }
  }
  
  dynamic "cleanup_policies" {
    for_each = var.env == "prod" ? [1] : []
    content {
      id     = "delete-old-versions"
      action = "DELETE"
      condition {
        older_than = "2592000s" # 30 days
        tag_state  = "UNTAGGED"
      }
    }
  }
}