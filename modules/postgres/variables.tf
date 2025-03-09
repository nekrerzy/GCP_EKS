# modules/postgres/variables.tf

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

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_vpc_connection_id" {
  description = "Private VPC Connection ID"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "app-database"
}

variable "db_user" {
  description = "Database username"
  type        = string
  default     = "app-user"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "dev_tier" {
  description = "DB tier for dev environment"
  type        = string
  default     = "db-f1-micro"
}

variable "prod_tier" {
  description = "DB tier for prod environment"
  type        = string
  default     = "db-custom-2-4096"
}