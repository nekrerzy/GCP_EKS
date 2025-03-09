# modules/spanner/main.tf

# Habilitar la API de Spanner de forma condicional
resource "google_project_service" "spanner_api" {
  count   = var.enabled ? 1 : 0
  service = "spanner.googleapis.com"
  disable_on_destroy = false
}

resource "google_spanner_instance" "instance" {
  count        = var.enabled ? 1 : 0
  name         = "${var.project_id}-${var.env}-spanner-instance"
  config       = "regional-${var.region}"
  display_name = "Spanner Instance - ${var.env}"
  
  # Para desarrollo, usa 1 nodo
  # Para producción, usa al menos 3 nodos
  num_nodes    = var.env == "prod" ? var.prod_node_count : var.dev_node_count
  
  depends_on = [google_project_service.spanner_api]
}

resource "google_spanner_database" "database" {
  count      = var.enabled ? 1 : 0
  instance   = google_spanner_instance.instance[0].name
  name       = var.db_name
  
  # Habilitar protección contra eliminación en producción
  deletion_protection = var.env == "prod" ? true : false
  
  depends_on = [google_spanner_instance.instance]
}