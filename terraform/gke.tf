# Service Account for GKE Node Pool
resource "google_service_account" "gke_service_account" {
  account_id   = var.gke_service_account_name
  display_name = "GKE Cluster Service Account"
}

# IAM Roles for GKE Service Account
resource "google_project_iam_member" "gke_sa_roles" {
  for_each = toset(var.gke_service_account_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.gke_service_account.email}"
}

# GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name               = "${var.project_id}-gke-cluster"
  location           = var.region
  network            = google_compute_network.vpc_network.id
  subnetwork         = google_compute_subnetwork.subnet[0].id
  remove_default_node_pool = true
  initial_node_count = 1

  # Specify the Kubernetes version for the control plane (master)
  min_master_version = var.gke_version

  # Configuring private cluster and security
  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # Node Pool Configuration
  node_pool {
    name              = "primary-node-pool"
    initial_node_count = var.initial_node_count
    autoscaling {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }
    node_config {
      machine_type    = var.node_machine_type
      service_account = google_service_account.gke_service_account.email
      oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
      metadata        = var.node_metadata
      tags            = var.node_tags
    }
      # Management settings for auto-upgrade
    management {
        auto_upgrade = true
      }
    }
  }