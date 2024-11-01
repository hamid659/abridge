#!/bin/sh


gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"

# Define variables
GCS_BUCKET_NAME="$PROJECT_ID-terraform-plan"  # Replace with your bucket name
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
PLAN_OUTPUT_FILE="/var/log/terraform_plan_${TIMESTAMP}.tfplan"

# Initialize Terraform
cd /abridge-test/terraform
terraform init

# Run the appropriate Terraform command
if [ "$COMMAND" = "apply" ]; then
  terraform apply -var-file="$TFVARS_PATH" -auto-approve
else
  terraform plan -var-file="$TFVARS_PATH" -out=/var/log/terraform_plan.tfplan
  # Copy the plan output to GCS
  gsutil cp "$PLAN_OUTPUT_FILE" gs://$GCS_BUCKET_NAME/
  # Construct the link to the copied plan
  PLAN_LINK="https://storage.googleapis.com/$GCS_BUCKET_NAME/$(basename $PLAN_OUTPUT_FILE)"
   # Output the link
  echo "Terraform plan has been saved to: $PLAN_LINK"
fi

# Keep the container running
tail -f /dev/null
