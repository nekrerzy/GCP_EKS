# modules/networking/variables.tf

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

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
}

variable "pod_cidr" {
  description = "CIDR range for GKE pods"
  type        = string
}

variable "service_cidr" {
  description = "CIDR range for GKE services"
  type        = string
}