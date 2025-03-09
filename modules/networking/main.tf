# modules/networking/main.tf

# VPC and Networking
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-${var.env}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-${var.env}-subnet"
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.vpc.id
  region        = var.region
  
  # Enable private Google access for Vertex AI
  private_ip_google_access = true
  
  # Secondary IP ranges for GKE pods and services
  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = var.pod_cidr
  }
  secondary_ip_range {
    range_name    = "service-range"
    ip_cidr_range = var.service_cidr
  }
}

# Cloud NAT for outbound internet access from private GKE nodes
resource "google_compute_router" "router" {
  name    = "${var.project_id}-${var.env}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.project_id}-${var.env}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# Firewall rules for GKE
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.project_id}-${var.env}-allow-internal"
  network = google_compute_network.vpc.name
  
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = [var.subnet_cidr, var.pod_cidr, var.service_cidr]
}

# Allow healthchecks for load balancers
resource "google_compute_firewall" "allow_health_check" {
  name    = "${var.project_id}-${var.env}-allow-health-check"
  network = google_compute_network.vpc.name
  
  allow {
    protocol = "tcp"
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}

# Global address for private services access (for PostgreSQL)
resource "google_compute_global_address" "private_ip_address" {
  name          = "${var.project_id}-${var.env}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
  depends_on = [ google_compute_network.vpc ]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  
}