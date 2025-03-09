# modules/postgres/main.tf

resource "google_sql_database_instance" "postgres" {
  name             = "${var.project_id}-${var.env}-postgres"
  database_version = "POSTGRES_17"
  region           = var.region
  
  depends_on = [var.private_vpc_connection_id]
  
  settings {
    tier = var.env == "prod" ? var.prod_tier : var.dev_tier
    edition = var.env == "prod" ? "ENTERPRISE_PLUS" : "ENTERPRISE"
    availability_type = var.env == "prod" ? "REGIONAL" : "ZONAL"
    
    backup_configuration {
      enabled            = var.env == "prod" ? true : false
      binary_log_enabled = false
      start_time         = "02:00"
      location           = var.region
    }
    
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
    }
  }
  
  deletion_protection = var.env == "prod" ? true : false
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "user" {
  name       = var.db_user
  instance   = google_sql_database_instance.postgres.name
  password = var.db_password
}