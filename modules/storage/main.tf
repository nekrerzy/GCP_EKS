# modules/storage/main.tf

# Cloud Storage bucket for Vertex AI
resource "google_storage_bucket" "vertex_bucket" {
  name     = "${var.project_id}-${var.env}-vertex-bucket"
  location = var.region
  
  force_destroy = var.env == "dev" ? true : false
  
  uniform_bucket_level_access = true
  
  versioning {
    enabled = var.env == "prod" ? true : false
  }
  
  lifecycle_rule {
    condition {
      age = var.env == "prod" ? 90 : 30
    }
    action {
      type = "Delete"
    }
  }
}

# Cloud Storage bucket for general application data
resource "google_storage_bucket" "app_bucket" {
  name     = "${var.project_id}-${var.env}-app-bucket"
  location = var.region
  
  force_destroy = var.env == "dev" ? true : false
  
  uniform_bucket_level_access = true
  
  versioning {
    enabled = var.env == "prod" ? true : false
  }
  
  lifecycle_rule {
    condition {
      age = var.env == "prod" ? 90 : 30
    }
    action {
      type = "Delete"
    }
  }
}