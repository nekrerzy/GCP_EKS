# environments/prod/variables.tf

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.10.0.0/16"
}

variable "pod_cidr" {
  description = "CIDR range for GKE pods"
  type        = string
  default     = "10.11.0.0/16"
}

variable "service_cidr" {
  description = "CIDR range for GKE services"
  type        = string
  default     = "10.12.0.0/16"
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for the GKE master"
  type        = string
  default     = "172.16.1.0/28"
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "app-database"
}

variable "db_user" {
  description = "PostgreSQL database username"
  type        = string
  default     = "app-user"
}

variable "db_password" {
  description = "PostgreSQL database password"
  type        = string
  sensitive   = true
}

variable "spanner_db_name" {
  description = "Spanner database name"
  type        = string
  default     = "app-spanner-db"
}

variable "gke_node_count" {
  description = "Number of GKE nodes"
  type        = number
  default     = 3
}

variable "gke_min_node_count" {
  description = "Minimum number of GKE nodes for autoscaling"
  type        = number
  default     = 2
}

variable "gke_max_node_count" {
  description = "Maximum number of GKE nodes for autoscaling"
  type        = number
  default     = 5
}