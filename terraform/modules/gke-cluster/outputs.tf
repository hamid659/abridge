output "vpc_network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.vpc_network.id
}

# output "subnet_ids" {
#   description = "List of IDs for the subnets created"
#   value       = [for subnet in google_compute_subnetwork.subnet : subnet.id]
# }

# output "private_subnet_services_cidr" {
#   value = google_compute_subnetwork.private_subnets[0].secondary_ip_range[0].ip_cidr_range
# }

# output "private_subnet_pods_cidr" {
#   value = google_compute_subnetwork.private_subnets[0].secondary_ip_range[1].ip_cidr_range
# }


output "gke_service_account_email" {
  description = "Email of the GKE service account"
  value       = google_service_account.gke_service_account.email
}

output "gke_cluster_endpoint" {
  description = "Endpoint of the GKE cluster"
  value       = google_container_cluster.gke_cluster.endpoint
}