# modules/api_enablement/main.tf

# Enable required APIs for the project
resource "google_project_service" "apis" {
  for_each = toset([
    "compute.googleapis.com",          # Compute Engine API
    "artifactregistry.googleapis.com", # Artifact Registry API
    "spanner.googleapis.com",          # Cloud Spanner API
    "aiplatform.googleapis.com",       # Vertex AI API
    "container.googleapis.com",        # Kubernetes Engine API
    "servicenetworking.googleapis.com", # Service Networking API
    "sqladmin.googleapis.com",         # Cloud SQL Admin API
    "iam.googleapis.com"               # IAM API
  ])

  project = var.project_id
  service = each.key

  disable_on_destroy = false
  timeouts {
    create = "30m"
    update = "40m"
  }
}