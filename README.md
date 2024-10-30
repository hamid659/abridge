# GCP Minimal Environment Terraform Module

This Terraform module provisions a minimal viable environment on Google Cloud Platform, including:
- A VPC network with customizable subnets
- A Google Kubernetes Engine (GKE) cluster
- A service account for the GKE cluster with defined IAM roles


# Prerequisites
Before you begin, ensure you have the following:

A Google Cloud Platform account.
Terraform installed on your machine.( verified version 1.6)
Google Cloud SDK installed and authenticated.
Basic knowledge of Kubernetes and GCP.

## Usage

```hcl
module "gcp_minimal_env" {
  source                = "./modules/gke-cluster"
  project_id            = "your-gcp-project-id"
  region                = "us-central1"
  vpc_name              = "example-vpc"
  public_subnets        = [{ name = "subnet-a", cidr = "10.0.1.0/24" }]
  private_subnets        = [{ name = "subnet-b", cidr = "10.0.4.0/24" }]
  cluster_name          = "example-gke-cluster"
  master_ipv4_cidr_block = "172.16.0.0/28"
  node_machine_type     = "e2-medium"
  min_node_count        = 1
  max_node_count        = 3
  node_tags             = ["gke-node"]
}
```

## Configuration
Adjust the parameters in your tfvars to customize your GKE cluster (e.g., number of nodes, machine types, etc.).


# Running Terraform in a Pod
You can also run Terraform using a pod with a Terraform image. This allows you to manage your infrastructure from within a Kubernetes environment. To do this:

Create a pod using terraform image with the pod configuration file located in ./k8s folder :

``` 
kubectl apply -f ./k8s/tf_pod.yaml
```