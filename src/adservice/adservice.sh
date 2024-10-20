#!/bin/bash

#workflow script to authenticate tag and push image to ECR

#  Variables
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="086308494025"
ADSERVICE_REPO_NAME="adservice:latest"


# Authenticate Docker with ECR
echo "Authenticating to AWS ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build the Docker image for the adservice
echo "Building the frontend Docker image..."
docker build -t adservice .

# Tag the adservice image with the ECR repository URI
echo "Tagging the adservice image..."
docker tag $ADSERVICE_REPO_NAME $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ADSERVICE_REPO_NAME

# Push the frontend image to the ECR repository
echo "Pushing the adservice image to ECR..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ADSERVICE_REPO_NAME



