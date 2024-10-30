# Call the VPC module
module "gcp-cluster" {
  source               = "./modules/gke-cluster"  
  project_id           = var.project_id
  region               = var.region
  cluster_name         = var.cluster_name
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  node_machine_type    = var.node_machine_type
  min_node_count       = var.min_node_count
  max_node_count       = var.max_node_count
}