# modules/gke/variables.tf

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

variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet Name"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the node pool"
  type        = number
  default     = 3
}

variable "min_node_count" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
  default     = 2
}

variable "max_node_count" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 6
}

variable "dev_machine_type" {
  description = "Machine type for dev environment"
  type        = string
  default     = "e2-standard-4"
}

variable "prod_machine_type" {
  description = "Machine type for prod environment"
  type        = string
  default     = "e2-standard-8"
}

variable "regional_cluster" {
  description = "Whether to create a regional cluster"
  type        = bool
  default     = true
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for the GKE master"
  type        = string
  default     = "172.16.0.0/28"
}

variable "cluster_deletion_protection" {
  description = "Whether to enable cluster deletion protection"
  type        = bool
  default     = true
}