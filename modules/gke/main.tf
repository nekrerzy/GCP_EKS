# modules/gke/main.tf

# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-${var.env}-gke"
  location = var.regional_cluster ? var.region : "${var.region}-a"
  deletion_protection = var.cluster_deletion_protection
  
  
  # We create the smallest possible default node pool and then delete it
  remove_default_node_pool = true
  initial_node_count       = 1
  
  network    = var.vpc_name
  subnetwork = var.subnet_name
  
  # Enable workload identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  
  # IP allocation policy for VPC-native cluster
  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-range"
    services_secondary_range_name = "service-range"
  }
  
  # Private or public cluster configuration based on environment
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = var.env == "prod" ? true : false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }
  
  # For dev, make the control plane publicly accessible
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.env == "dev" ? [1] : []
      content {
        cidr_block   = "0.0.0.0/0"
        display_name = "Allow all for development"
      }
    }
  }
  
  # Release channel for GKE updates
  release_channel {
    channel = var.env == "prod" ? "STABLE" : "REGULAR"
  }
}

# Node Pools
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.project_id}-${var.env}-node-pool"
  location   = var.regional_cluster ? var.region : "${var.region}-a"
  cluster    = google_container_cluster.primary.name
  node_count = var.env == "prod" ? var.node_count : 2

  # Auto-scaling configuration for production
  dynamic "autoscaling" {
    for_each = var.env == "prod" ? [1] : []
    content {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = var.env
    }

    # Use smaller machine for dev, larger for prod
    machine_type = var.env == "prod" ? var.prod_machine_type : var.dev_machine_type
    disk_size_gb = var.env == "prod" ? 100 : 50
    
    # Enable workload identity on nodes
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}