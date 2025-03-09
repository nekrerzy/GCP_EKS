# modules/cloud_dns/variables.tf

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

variable "dns_base_name" {
  description = "Nombre base para el DNS interno (ejemplo: internal.example)"
  type        = string
  default     = "internal.app"
}

variable "postgres_ip" {
  description = "IP privada de la instancia de PostgreSQL"
  type        = string
}

variable "spanner_instance" {
  description = "Nombre de la instancia de Spanner"
  type        = string
}

variable "spanner_enabled" {
  description = "Indica si Spanner está habilitado"
  type        = bool
  default     = false
}

variable "app_ip" {
  description = "IP de la aplicación (si está disponible)"
  type        = string
  default     = ""
}

variable "redis_host" {
  description = "IP privada de la instancia de Redis"
  type        = string
  
}