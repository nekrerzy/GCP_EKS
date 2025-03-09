# modules/vertex_ai/variables.tf

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "env" {
  description = "Environment name (dev or prod)"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "storage_bucket_name" {
  description = "Name of storage bucket for Vertex AI"
  type        = string
}