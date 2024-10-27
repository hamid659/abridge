variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "Region where resources will be deployed"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "gke-vpc"
}

variable "vpc_mtu" {
  description = "MTU setting for the VPC"
  type        = number
  default     = 1460
}

variable "subnet_configs" {
  description = "Configuration for subnets within the VPC"
  type = list(object({
    name = string
    cidr = string
  }))
}

variable "enable_flow_logs" {
  description = "Enable flow logs for the subnets"
  type        = bool
  default     = false
}

variable "gke_service_account_name" {
  description = "Service account name for GKE"
  type        = string
  default     = "gke-sa"
}

variable "gke_service_account_roles" {
  description = "Roles assigned to the GKE service account"
  type        = list(string)
  default     = ["roles/container.clusterAdmin", "roles/compute.networkAdmin"]
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "minimal-gke-cluster"
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for the GKE master's private IP"
  type        = string
  default     = "172.16.0.0/28"
}

variable "node_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "initial_node_count" {
  description = "Initial node count in the node pool"
  type        = number
  default     = 1
}

variable "min_node_count" {
  description = "Minimum node count for autoscaling"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum node count for autoscaling"
  type        = number
  default     = 3
}

variable "node_tags" {
  description = "Network tags to assign to nodes"
  type        = list(string)
  default     = ["gke-node"]
}

variable "node_metadata" {
  description = "Metadata to assign to the GKE nodes"
  type        = map(string)
  default     = {
    disable-legacy-endpoints = "true"
  }
}

variable "gke_version" {
  description = "The Kubernetes version for the GKE cluster."
  type        = string
  default     = "1.28"  # Adjust the default version as needed
}