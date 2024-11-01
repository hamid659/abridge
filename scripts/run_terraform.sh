#!/bin/sh


gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"

# Define variables
PROJECT_ID=$(grep 'project_id' "$TFVARS_PATH" | sed 's/project_id = "\(.*\)"/\1/')
GCS_BUCKET_NAME="$PROJECT_ID-terraform-plan"  # Replace with your bucket name
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
PLAN_OUTPUT_FILE="/var/log/terraform_plan_${TIMESTAMP}.txt"
SIGNATURE_DURATION="1h"

# Initialize Terraform
cd /abridge-test/terraform
terraform init

# Run the appropriate Terraform command
if [ "$COMMAND" = "apply" ]; then
  terraform apply -var-file="$TFVARS_PATH" -auto-approve
else
  terraform plan -var-file="$TFVARS_PATH" -no-color > "$PLAN_OUTPUT_FILE"
  # Copy the plan output to GCS
  gsutil cp "$PLAN_OUTPUT_FILE" gs://$GCS_BUCKET_NAME/
  # Construct the link to the copied plan
  PLAN_LINK="https://storage.googleapis.com/$GCS_BUCKET_NAME/$(basename $PLAN_OUTPUT_FILE)"
   # Output the link
  echo "Terraform plan has been saved to: $PLAN_LINK"

  # Create a signed URL for the plan output
  SIGNED_URL=$(gsutil signurl -d "$SIGNATURE_DURATION" "$GOOGLE_APPLICATION_CREDENTIALS" "gs://$GCS_BUCKET_NAME/$(basename "$PLAN_OUTPUT_FILE")")
  
  # Output the signed URL
  echo "Signed URL for the Terraform plan: $SIGNED_URL"
fi

# Keep the container running
tail -f /dev/null
