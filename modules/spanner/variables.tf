# modules/spanner/variables.tf

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

variable "db_name" {
  description = "Spanner database name"
  type        = string
}

variable "dev_node_count" {
  description = "Number of nodes for dev environment"
  type        = number
  default     = 1
}

variable "prod_node_count" {
  description = "Number of nodes for prod environment"
  type        = number
  default     = 3
}

variable "enabled" {
  description = "Indica si Spanner debe ser habilitado y desplegado"
  type        = bool
  default     = true
}