import argparse
import os
import subprocess

def update_backend_file(bucket_name):
    backend_tf_content = f"""
terraform {{
  backend "gcs" {{
    bucket     = "{bucket_name}"
    prefix     = "terraform/state"
  }}
}}
"""
    backend_file_path = os.path.join(os.path.dirname(__file__), '../terraform/backend.tf')
    
    with open(backend_file_path, 'w') as backend_file:
        backend_file.write(backend_tf_content.strip())
    
    print(f"Updated backend file at {backend_file_path} with bucket name: {bucket_name}")

def run_terraform_action(action, tfvars_path):
    terraform_directory = os.path.abspath(os.path.join(os.path.dirname(__file__), '../terraform'))
    
    command = ['terraform', action]
    if tfvars_path:
        command.extend(['-var-file', tfvars_path])
    
    # Add '-auto-approve' for apply and destroy actions
    if action in ['apply', 'destroy']:
        command.append('-auto-approve')
    
    try:
        result = subprocess.run(command, cwd=terraform_directory, check=True)
        print(f"Terraform {action} completed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error running terraform {action}: {e}")

def main():
    parser = argparse.ArgumentParser(description='Set Terraform backend with GCS bucket name and run terraform init.')
    parser.add_argument('--project-id', type=str, required=True, help='The project ID to derive the bucket name from.')
    parser.add_argument('--tf-action', choices=['plan', 'apply', 'destroy'], required=True, help='Specify whether to run terraform plan, apply, or destroy.')
    parser.add_argument('--tfvars-path', type=str, help='Path to the tfvars file to use.')

    args = parser.parse_args()
    bucket_name = f"{args.project_id}-terraform-state"  # Use project-id to create bucket name
    
    update_backend_file(bucket_name)
    run_terraform_action(args.tf_action, args.tfvars_path)  # Use args.tfvars_path

if __name__ == '__main__':
    main()
