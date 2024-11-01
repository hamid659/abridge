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
./scripts/setup_terraform-buckets.sh  my-gcp-project US
``` 

## Module Usage

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



# Using RUN Terraform  Python Script
This script allows you to set the Terraform backend to a Google Cloud Storage (GCS) bucket and execute Terraform actions such as plan or apply. Below are instructions on how to use the script.
- Ensure you have Python installed (version 3.6 or higher).
- Install the necessary packages if required (e.g., subprocess is included in the standard library).
- Make sure you have Terraform installed and configured in your environment.
- Ensure you have the gsutil command-line tool installed to upload files to GCS.

## Script Location
The script is located in the scripts directory of your project. Navigate to this directory in your terminal.

## Usage
```
python run_terraform.py --project-id <YOUR_PROJECT_ID> --tf-action <ACTION> --tfvars-path <PATH_TO_TFVARS_FILE>
```

- --project-id <YOUR_PROJECT_ID>: Specify the Google Cloud Project ID, which will be used to derive the GCS bucket name (e.g., my-gcp-project).
- --tf-action <ACTION>: Specify the Terraform action you want to execute. This can be either:
- - plan: To create an execution plan.
- - apply: To apply the changes required to reach the desired state of the configuration.
- --tfvars-path <PATH_TO_TFVARS_FILE>: Provide the path to the .tfvars file that contains the variable definitions for the Terraform configuration.


## What the Script Does
- Update the Backend File: The script creates or updates the backend.tf file in the ../terraform directory with the specified GCS bucket name.

- Run Terraform Command: Based on the specified action, it executes the corresponding Terraform command (plan or apply). If the action is apply, it automatically approves the changes without prompting for confirmation.

- Outputs: The script will print messages indicating the success or failure of each operation, along with the path to the updated backend file.

# Running Terraform in a Pod
You can also execute Terraform within a Kubernetes pod using a Terraform image. This approach enables you to run Terraform code in a consistent pod environment, ensuring that all necessary libraries and dependencies are available without the need for local installations. This method simplifies the management of your Terraform infrastructure and enhances reproducibility across different environments.

Create a pod using terraform image with the pod configuration file located in ./k8s folder :

``` 
kubectl apply -f ./k8s/tf_pod.yaml
```


