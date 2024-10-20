#!/bin/bash
# Workflow Script (Multiple Microserves)
# Workflow script to authenticate, tag, and push images to ECR for multiple microservices

#  Variables
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="086308494025"  # AWS Account ID

MICROSERVICES=("cartservice" "checkoutservice" "currencyservice" "emailservice" "loadgenerator" "paymentservice" "productcatalogservice" "recommendationservice" "shippingservice" "shoppingassistantservice" "adservice" "frontend")


#for each in "${MICROSERVICES[@]}"; do
    # Authenticate against ECR
    #echo "Logging into Docker"
    #aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

    # build the images
    #echo "Building Docker image for $each"
    #docker build -t $each ./MICROSERVICESPROJECT/project1/src/$each

    #Tag the images
    #echo "Tagging Docker image for $each"
    #docker tag $each:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$each:latest
    
    # Push the images to ECR
    #echo "Pushing Docker image for $each"
    #docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$each:latest
#done

#echo "All microservices have been successfully built, tagged, and pushed to ECR!"



# Loop through each microservice and build, tag, and push to ECR

for SERVICE in "${MICROSERVICES[@]}"; do
    echo "Processing $SERVICE..."

    # Retrieve an authentication token and authenticate your Docker client to your registry.
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 086308494025.dkr.ecr.us-east-1.amazonaws.com
   
    #Build the Docker image for the current microservice
    echo "Building the Docker image for $SERVICE..."
    docker build -t $SERVICE ./src/src/$SERVICE
    docker build -t cartservice ./src/src/cartservice/src

    # Tag the microservice image with the ECR repository URI
    echo "Tagging the $SERVICE image..."
    docker tag $SERVICE:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$SERVICE:latest

   # Check if the image already exists in ECR
   IMAGE_EXISTS=$(aws ecr describe-images --repository-name $SERVICE --image-ids imageTag=latest --region $AWS_REGION 2>&1)

      if [[ $IMAGE_EXISTS == *"ImageNotFoundException"* ]]; then
        # Push the microservice image to the ECR repository if it doesn't exist
        echo "Pushing the $SERVICE image to ECR..."

        # Push the microservice image to the ECR repository
        echo "Pushing the $SERVICE image to ECR..."
        docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$SERVICE:latest
    
        if docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$SERVICE:latest; then
           echo "$SERVICE has been successfully pushed to ECR!"
        else
           echo "Failed to push $SERVICE to ECR."
        fi
    fi
done 

