#!/bin/bash
# azure-node-setup.sh
# Run this from any directory:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/azure-node/azure-node-setup.sh)"
# Explained at https://wilsonmar.github.io/azure-cloud
# And https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task
# Based on Microsoft Learn module Administer containers in Azure at 
   # https://docs.microsoft.com/learn/paths/administer-containers-in-azure

# This is idempotent by removing what is left over from previous run.

ACR_NAME="myApp123Registry"  # this must be unique among all others on Azure
   # Where myApp123 = service short name per https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions
ACR_LOCATION="southcentralus"

# To create an Azure Container Registry for an app:
#    (A premium registry SKU is needed for geo-replication.
RES_GROUP="e2aa9a5e-9731-4095-a768-ea72a3026c19"
   #RES_GROUP=$ACR_NAME ? in https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task
CONTAINER="helloacrtasks:v1"
# Create an Azure Container Registry for an app:
az acr create --name $ACR_NAME --sku Premium \
   --resource-group $RES_GROUP

   # Sample response:
   # "id": "/subscriptions/dbef726d-5981-44bc-acf5-13a9f7a80617/resourceGroups/e2aa9a5e-9731-4095-a768-ea72a3026c19/providers/Microsoft.ContainerRegistry/registries/myApp123Registry",
   # "location": "southcentralus",
   # "loginServer": "myapp123registry.azurecr.io",

# Bring in Dockerfile:
curl "https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/azure-node/Dockerfile"

# Build a Docker container image containing Node:
   az acr build --registry $ACR_NAME \
   --image $CONTAINER .  
      #    Don't forget the "." at the end to denote the current folder.

# Verify the image:
   az acr repository list \
   --name $ACR_NAME --output table
      # Response: helloacrtasks (= $CONTAINER)

# Enable the registry admin account
az acr update -n $ACR_NAME --admin-enabled true
   # Response includes: "location": "southcentralus",

# Show password and password2:
az acr credential show --name $ACR_NAME
   # TODO: Capture :
   ACR_PASSWORD="JZLeM1EQm+wGboaKhrhER2Y3PcFJ9ogr"
   ACR_PASSWORD2="cY/sEfQSPZxaUYi=NrkUSoDsf9DVqj0w"
   # Response includes:
   # "location": "southcentralus",
   # "loginServer": "myapp123registry.azurecr.io",

# Deploy a container with Azure CLI:
az container create \
    --resource-group $RES_GROUP \
    --name acr-tasks \
    --image $ACR_NAME.azurecr.io/helloacrtasks:v1 \
    --registry-login-server $ACR_NAME.azurecr.io \
    --ip-address Public \
    --location $ACR_LOCATION \
    --registry-username $ACR_PASSWORD \
    --registry-password $ACR_PASSWORD2

# BLAH: Here's where I'm stuck:
# The image 'myApp123Registry.azurecr.io/helloacrtasks:v1' in container group 'acr-tasks' is not accessible. 
# Please check the image and registry credential.

# Get the IP address of the Azure container instance using the following command.
RESPONSE=$(az container show --name acr-tasks \
   --query ipAddress.ip \
   --resource-group $RES_GROUP \
   --output table 
   )

# TODO: parse
IP_ADDRESS=RESPONSE | grep ???

# Now view the website using the ip address
curl $IP_ADDRESS

# Clean up resources:
az container delete --resource-group $RES_GROUP \
   --name $CONTAINER
