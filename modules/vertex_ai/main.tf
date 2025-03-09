# modules/vertex_ai/main.tf

# Enable Vertex AI API
resource "google_project_service" "vertex_ai" {
  service = "aiplatform.googleapis.com"
  disable_on_destroy = false
}

# Service Account for Vertex AI
resource "google_service_account" "vertex_ai_sa" {
  account_id   = "vertex-ai-${var.env}-sa"
  display_name = "Vertex AI Service Account (${var.env})"
}

# Grant permissions to the Vertex AI service account
resource "google_project_iam_member" "vertex_ai_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.vertex_ai_sa.email}"
}

resource "google_project_iam_member" "storage_object_user" {
  project = var.project_id
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:${google_service_account.vertex_ai_sa.email}"
}

# Grant access to the specific storage bucket
resource "google_storage_bucket_iam_member" "vertex_storage_admin" {
  bucket = var.storage_bucket_name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.vertex_ai_sa.email}"
}