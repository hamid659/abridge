#!/bin/bash

# Check if the necessary arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <project_id> <LOCATION>"
    echo "Example: $0 project_id US"
    exit 1
fi

# Assign arguments to variables
BUCKET_NAME=$1-terraform-state
LOCATION=$2

# Create the bucket
gcloud storage buckets create gs://$BUCKET_NAME --location=$LOCATION 
gsutil versioning set on

# Check if the bucket was created successfully
if [ $? -eq 0 ]; then
    echo "Bucket gs://$BUCKET_NAME created successfully in $LOCATION."
else
    echo "Failed to create the bucket. Please check your permissions and bucket name."
    exit 1
fi
