# Project ID where the resources will be created
project_id = "hamid-test-24"

# GKE Cluster Configuration
region             = "us-central1"
cluster_name       = "dev"
k8s_version        = "1.29.9-gke.1177000"  # Specify the GKE Kubernetes version

# Public subnets
public_subnets = [
{
    name = "public-subnet-1"
    cidr = "10.0.0.0/24"  
  },
  {
    name = "public-subnet-2"
    cidr = "10.0.1.0/24"  
  },
]

# Private subnets
private_subnets = [
  {
    name          = "private-subnet-1"
    cidr          = "10.0.2.0/24"
    services_cidr = "10.0.20.0/23"
    pods_cidr     = "10.0.24.0/21"
       
  },
  {
    name = "private-subnet-2"
    cidr = "10.0.4.0/24"
    services_cidr   = "10.0.40.0/23"
    pods_cidr   = "10.0.48.0/21"
  }
]

# Private Cluster Config
master_ipv4_cidr_block = "10.0.10.0/28"

# Node Pool Configuration
node_machine_type  = "e2-micro"
min_node_count     = 1
max_node_count     = 1

