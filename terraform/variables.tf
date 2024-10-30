variable "project_id" {
  type        = string
  description = "gcp project id"
}

variable "region" {
  type        = string
  description = "gcp region where the resources are being created"
}

variable "private_subnets" {
  description = "Configuration for private subnets within the VPC"
  type = list(object({
    name = string
    cidr = string
    pods_cidr = string
    services_cidr = string
  }))
}

variable "public_subnets" {
  description = "Configuration for public subnets within the VPC"
  type = list(object({
    name = string
    cidr = string
  }))
}

variable "cluster_name" {
  type        = string
  description = "gke cluster name, used for vpc and subnets"
}

variable "k8s_version" {
  type        = string
  default     = "1.29"
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for the GKE master's private IP"
  type        = string
  default     = "10.16.10.0/28"
}

variable "node_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-micro"
}

variable "min_node_count" {
  description = "Minimum node count for autoscaling"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum node count for autoscaling"
  type        = number
  default     = 2
}