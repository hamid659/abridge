# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = false
  description             = "VPC network for GKE cluster and resources"
  mtu                     = var.vpc_mtu
  routing_mode            = "REGIONAL"
}

# Subnet Creation in VPC Network
resource "google_compute_subnetwork" "subnet" {
  count                    = length(var.subnet_configs)
  name                     = var.subnet_configs[count.index]["name"]
  ip_cidr_range            = var.subnet_configs[count.index]["cidr"]
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
}

