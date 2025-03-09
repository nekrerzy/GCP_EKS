# environments/dev/variables.tf

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
  default     = "10.0.0.0/16"
}

variable "pod_cidr" {
  description = "CIDR range for GKE pods"
  type        = string
  default     = "10.1.0.0/16"
}

variable "service_cidr" {
  description = "CIDR range for GKE services"
  type        = string
  default     = "10.2.0.0/16"
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for the GKE master"
  type        = string
  default     = "172.16.0.0/28"
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


variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "app.example.com"
}

variable "use_ssl" {
  description = "Enable SSL for ingress"
  type        = bool
  default     = true
}

variable "enable_cloud_armor" {
  description = "Enable Cloud Armor WAF protection"
  type        = bool
  default     = false
}

variable "cluster_deletion_protection" {
  description = "Enable cluster deletion protection"
  type        = bool
  default     = false
  
}

variable "enable_spanner" {
  description = "Indica si se debe habilitar y desplegar Spanner"
  type        = bool
  default     = true  
}

