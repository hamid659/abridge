# Service Account for GKE Node Pool
resource "google_service_account" "gke_service_account" {
  depends_on = [google_project_service.enable_apis]
  account_id   = "${var.cluster_name}-gke-cluster-sa"
  display_name = "GKE Cluster Service Account"
  project  = var.project_id
}

# IAM Roles for GKE Service Account
resource "google_project_iam_member" "gke_sa_roles" {
  depends_on = [google_project_service.enable_apis]
  for_each = toset(var.gke_service_account_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.gke_service_account.email}"
}

# GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  depends_on = [google_project_service.enable_apis,google_compute_subnetwork.private_subnets]
  project            = var.project_id
  name               = var.cluster_name
  location           = var.region
  network            = google_compute_network.vpc_network.id
  subnetwork         = google_compute_subnetwork.private_subnets[0].id
  #remove_default_node_pool = true

  # Specify the Kubernetes version for the control plane (master)
  min_master_version = var.k8s_version

  # Configuring private cluster and security
  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }
  
  #IP allocation policy for Pods and Services
  # ip_allocation_policy {
  #   services_ipv4_cidr_block = "/21" # Services IP range
  #   cluster_ipv4_cidr_block = "/21"  # Pod IP range
  # }
  release_channel {
    channel = "REGULAR" # Options: STABLE, REGULAR, PREVIEW
  }

  # Node Pool Configuration
  node_pool {
    name              = "primary-node-pool"
    autoscaling {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
      location_policy = "BALANCED"
    }
    node_config {
      machine_type    = var.node_machine_type
      disk_size_gb    = 100
      disk_type       = "pd-balanced"
      image_type        = "COS_CONTAINERD"
      local_ssd_count   = 0
      service_account = google_service_account.gke_service_account.email
      oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
      metadata        = {
        "disable-legacy-endpoints" = "true"}
      tags            = var.node_tags
    }
      # Management settings for auto-upgrade
    management {
        auto_upgrade = true
      }
      
    }
  }