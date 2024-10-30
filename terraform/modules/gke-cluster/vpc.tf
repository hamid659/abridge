# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "main-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
  description             = "VPC network for GKE cluster and resources"
  mtu                     = var.vpc_mtu
  routing_mode            = "REGIONAL"
  depends_on = [google_project_service.enable_apis]
}

# Private Subnet Creation in VPC Network
resource "google_compute_subnetwork" "private_subnets" {
  depends_on = [google_compute_network.vpc_network]
  count                    = length(var.private_subnets)
  name                     = var.private_subnets[count.index]["name"]
  ip_cidr_range            = var.private_subnets[count.index]["cidr"]
  project                  = google_compute_network.vpc_network.project
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
  # Adding secondary IP ranges for Alias IP
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = var.private_subnets[count.index]["services_cidr"]
  }

   secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = var.private_subnets[count.index]["pods_cidr"]
  }
  # lifecycle {
  #   create_before_destroy = true
  # }
}

# Public Subnet Creation in VPC Network
resource "google_compute_subnetwork" "public_subnets" {
  count                    = length(var.public_subnets)
  name                     = var.public_subnets[count.index]["name"]
  ip_cidr_range            = var.public_subnets[count.index]["cidr"]
  project                  = google_compute_network.vpc_network.project
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = false
  depends_on = [google_project_service.enable_apis]
}

# NAT Gateway for Private Subnet
resource "google_compute_router" "nat_router" {
  project = var.project_id
  region  = var.region
  name    = "${var.project_id}-nat-router"
  network = google_compute_network.vpc_network.id
  
}

resource "google_compute_router_nat" "nat_config" {
  project                            = google_compute_router.nat_router.project
  name                               = "${var.project_id}-nat-config"
  router                             = google_compute_router.nat_router.name
  region                             = google_compute_router.nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = google_compute_subnetwork.private_subnets
    content {
      name                    = subnetwork.value.name
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }
}

# Firewall Rule for Private Subnets (Allow Internal Traffic Only)
resource "google_compute_firewall" "private_subnet_fw" {
  project = var.project_id
  name    = "private-allow-internal"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/16"]  # Internal traffic only (replace with VPC CIDR block)
  target_tags   = ["private-access"]  # Apply to instances with the "private-access" tag
}