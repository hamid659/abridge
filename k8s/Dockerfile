# Use a base image with a Linux distro
FROM ubuntu:22.04

# Install curl, unzip, and other dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    gnupg \
    software-properties-common \
    && apt-get clean

# Install Terraform
ENV TERRAFORM_VERSION=1.6.0
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform.zip

# Install gcloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
    | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && apt-get install -y google-cloud-sdk

# Set environment variables for Terraform and gcloud
ENV GOOGLE_APPLICATION_CREDENTIALS="/var/secrets/gcp/gcp-credentials.json"



