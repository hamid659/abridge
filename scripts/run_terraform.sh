#!/bin/sh

# Initialize Terraform
terraform init

# Run the appropriate Terraform command
if [ "$COMMAND" = "apply" ]; then
  terraform apply -var-file="$TFVARS_PATH" -auto-approve
else
  terraform plan -var-file="$TFVARS_PATH" -out=/var/log/terraform_output/terraform_plan.tfplan
fi

# Keep the container running
tail -f /dev/null
