# environments/dev/variables.tf

variable "credentials" {
  type        = string
  description = "Contenido JSON de la cuenta de servicio"
  sensitive   = true
  default     = <<EOF
{
  "client_id": "764086051850-6qr4p6gpi6hn506pt8ejuq83di341hur.apps.googleusercontent.com",
  "client_secret": "d-FL95Q19q7MQmFpd7hHD0Ty",
  "quota_project_id": "synthaud",
  "refresh_token": "1//05tlWxp8-OfNXCgYIARAAGAUSNwF-L9Ir2H_n4GfSg4AusLwfHrF9WIT-lUtb_O6Wa7b0h9YsNktJz5lE_fXQs_gJ86CZlIVPtSs",
  "type": "authorized_user",
  "universe_domain": "googleapis.com"
}
EOF
}

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

