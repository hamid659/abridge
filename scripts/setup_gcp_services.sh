#!/bin/bash

# Define the project ID
PROJECT_ID=$1  

# List of services to enable
SERVICES=(
  "iam.googleapis.com"
  "compute.googleapis.com"
  "cloudresourcemanager.googleapis.com"
  "artifactregistry.googleapis.com"
  "container.googleapis.com"
)

# Enable each service
for SERVICE in "${SERVICES[@]}"; do
  gcloud services enable "$SERVICE" --project="$PROJECT_ID"
done
