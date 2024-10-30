
#!/bin/bash

# Check if the required number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <PROJECT_ID> <SERVICE_ACCOUNT_NAME>"
    exit 1
fi

# Assign input arguments to variables
PROJECT_ID="$1"
GSA_NAME="$2"

# Construct the full service account email
GSA_EMAIL="${GSA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

# Add IAM policy binding to grant Owner role
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:$GSA_EMAIL" \
    --role="roles/owner"

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "Successfully added IAM policy binding for $GSA_EMAIL with Owner role in project $PROJECT_ID."
else
    echo "Failed to add IAM policy binding. Please check the error message above."
fi


