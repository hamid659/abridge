#!/bin/bash

# Check if the necessary arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <project_id> <LOCATION>"
    echo "Example: $0 project_id US"
    exit 1
fi

# Assign arguments to variables
PROJECT_ID=$1
LOCATION=$2
STATE_BUCKET_NAME="${PROJECT_ID}-terraform-state"
PLAN_BUCKET_NAME="${PROJECT_ID}-terraform-plan"

# Function to create a bucket if it doesn't exist
create_bucket_if_not_exists() {
    BUCKET_NAME=$1
    if gsutil -q stat "gs://$BUCKET_NAME"; then
        echo "Bucket gs://$BUCKET_NAME already exists."
    else
        # Attempt to create the bucket
        if gcloud storage buckets create "gs://$BUCKET_NAME" --location="$LOCATION"; then
            echo "Bucket gs://$BUCKET_NAME created successfully in $LOCATION."
            gsutil versioning set on "gs://$BUCKET_NAME"
        else
            # Check for specific error codes and handle them
            if [[ $? -eq 1 ]]; then
                echo "Bucket gs://$BUCKET_NAME may already exist or another error occurred."
                echo "Error: Make sure you have the correct permissions and that the bucket name is unique."
            else
                echo "Failed to create the bucket gs://$BUCKET_NAME. Please check your permissions and bucket name."
                exit 1
            fi
        fi
    fi
}

# Create state bucket
create_bucket_if_not_exists "$STATE_BUCKET_NAME"

# Create plan bucket
create_bucket_if_not_exists "$PLAN_BUCKET_NAME"
