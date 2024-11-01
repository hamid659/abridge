# GCP Minimal Environment Terraform Module

This Terraform module provisions a minimal viable environment on Google Cloud Platform, including:
- A VPC network with customizable subnets
- A Google Kubernetes Engine (GKE) cluster
- A service account for the GKE cluster with defined IAM roles


# Prerequisites
Before you begin, ensure you have the following:

- A Google Cloud Platform account.
- Terraform installed on your machine.( verified version 1.6).
- Google Cloud SDK installed and authenticated.
- Basic knowledge of Kubernetes and GCP.

## Setting Up the Terraform Backend Bucket

The env_init.sh script creates a Google Cloud Storage (GCS) bucket to be used as a backend for Terraform state management. This allows you to store your Terraform state files in a centralized and secure location.
```
./scripts/env_init.sh  my-gcp-project US
``` 

## Usage

```hcl
module "gcp_minimal_env" {
  source                = "./modules/gke-cluster"
  project_id            = "your-gcp-project-id"
  region                = "us-central1"
  cluster_name          = "example-gke-cluster"
  public_subnets        = [{ name = "subnet-a", cidr = "10.0.1.0/24" }]
  private_subnets        = [{ name = "subnet-b", cidr = "10.0.4.0/24" }]
  master_ipv4_cidr_block = "10.0.10.0/28"
  node_machine_type     = "e2-micro"
  min_node_count        = 1
  max_node_count        = 3
}
```

## Configuration
Adjust the parameters in your tfvars to customize your GKE cluster (e.g., number of nodes, machine types, etc.).


# Running Terraform in a Pod
You can also execute Terraform within a Kubernetes pod using a Terraform image. This approach enables you to run Terraform code in a consistent pod environment, ensuring that all necessary libraries and dependencies are available without the need for local installations. This method simplifies the management of your Terraform infrastructure and enhances reproducibility across different environments.

Create a pod using terraform image with the pod configuration file located in ./k8s folder :

``` 
kubectl apply -f ./k8s/tf_pod.yaml
```

# Key Components
##  Volume Mounts: 
- GCP credentials are mounted as a read-only volume, ensuring that sensitive information is kept secure.
##  Environment Variables:
- GOOGLE_APPLICATION_CREDENTIALS: Specifies the path to the GCP credentials JSON file within the Pod.
- COMMAND:  Specifies the Terraform command to run. The default is set to plan, but this can be overridden.
- TFVARS_PATH: Specifies the path to the Terraform variable file (*.tfvars). The default is set to "/abridge-test/terraform/environments/dev.tfvars.

## Command Execution:
- The command section specifies a shell command to run when the container starts.
- The args section installs Git, clones the specified repository, and runs a custom script (run_terraform.sh) that contains the Terraform commands.