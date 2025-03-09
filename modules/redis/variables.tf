# modules/redis/variables.tf

variable "project_id" {
  description = "ID del proyecto GCP"
  type        = string
}

variable "env" {
  description = "Entorno (dev o prod)"
  type        = string
}

variable "region" {
  description = "Región de GCP"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "dev_memory_size_gb" {
  description = "Tamaño de memoria en GB para entorno de desarrollo"
  type        = number
  default     = 1
}

variable "prod_memory_size_gb" {
  description = "Tamaño de memoria en GB para entorno de producción"
  type        = number
  default     = 5
}

variable "redis_version" {
  description = "Versión de Redis"
  type        = string
  default     = "REDIS_7_0"
}

variable "replica_count" {
  description = "Número de replicas para entorno de producción"
  type        = number
  default     = 1
}

variable "service_account_email" {
  description = "Email de la cuenta de servicio que tendrá acceso a Redis"
  type        = string
}