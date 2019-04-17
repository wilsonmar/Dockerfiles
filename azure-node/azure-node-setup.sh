#!/bin/bash
# azure-node-setup.sh
# Run this from within an Azure CLI prompt:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/azure-node/azure-node-setup.sh)"
# Explained at https://wilsonmar.github.io/azure-cloud
# And https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task
# Based on Microsoft Learn module Administer containers in Azure at 
   # https://docs.microsoft.com/learn/paths/administer-containers-in-azure

# This is idempotent by removing what is left over from previous run.

ACR_NAME="myApp123Registry"  # this must be unique among all others on Azure
   # Where myApp123 = service short name per https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions
ACR_LOCATION="southcentralus"  # eastus, etc.
ACR_LOCATION2="japaneast"

# To create an Azure Container Registry for an app:
#    (A premium registry SKU is needed for geo-replication.
RES_GROUP="b5cb3c0d-4813-4932-8929-031ff63e5846"
   #RES_GROUP=$ACR_NAME ? in https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task
CONTAINER="helloacrtasks:v1"

STORAGE_ACCOUNT_NAME='mystorageaccount'$RANDOM
FILE_SHARE_NAME="aci-share-demo"

# FIXME: Azure CLI does not recognize built-in $RANDOM within a bash script:
#COSMOS_DB_NAME="aci-cosmos-db-$RANDOM"
# So we do this:
COSMOS_DB_NAME='aci-cosmos-db-'$RANDOM
echo "COSMOS_DB_NAME=$COSMOS_DB_NAME"


###########################

# TODO: Add clean-up actions

function jsonValue() {
KEY=$1
num=$2
awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p
}

# Print values give second argument:
curl -s -X GET http://twitter.com/users/show/$1.json | jsonValue profile_image_url 1

exit

############################

# Create an Azure Container Registry (like Docker Hub) for an app:
az acr create --name $ACR_NAME \
   --resource-group $RES_GROUP \
   --admin-enabled true \
   --sku Premium \
   --resource-group $RES_GROUP

   # Sample response:
   # "id": "/subscriptions/dbef726d-5981-44bc-acf5-13a9f7a80617/resourceGroups/e2aa9a5e-9731-4095-a768-ea72a3026c19/providers/Microsoft.ContainerRegistry/registries/myApp123Registry",
   # "location": "southcentralus",
   # "loginServer": "myapp123registry.azurecr.io",

# From visualstudio.com (Azure DevOps Dashboard):
RES_GROUP="b5cb3c0d-4813-4932-8929-031ff63e5846"


# Based on https://docs.microsoft.com/en-us/learn/modules/deploy-run-container-app-service/3-exercise-build-images
git clone https://github.com/MicrosoftDocs/mslearn-deploy-run-container-app-service.git
cd mslearn-deploy-run-container-app-service

# Bring in Dockerfile:
curl "https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/azure-node/Dockerfile"
# Build a Docker container image containing Node:
   az acr build --file Dockerfile \
   --registry $ACR_NAME \
   --image $CONTAINER .  
      #    Don't forget the "." at the end to denote the current folder.

# Verify the image:
   az acr repository list \
   --name $ACR_NAME --output table
      # Response: helloacrtasks (= $CONTAINER)

# Enable the registry admin account
az acr update -n $ACR_NAME --admin-enabled true
   # Response includes: "location": "southcentralus",


############################

# Create Cosmos (NOSQL) db:
COSMOS_DB_ENDPOINT=$(az cosmosdb create \
  --resource-group $RES_GROUP \
  --name $COSMOS_DB_NAME \
  --query documentEndpoint \
  --output tsv)
   # Exit if blank
   if ! [[ -z "${COSMOS_DB_ENDPOINT// }" ]]; then  #it's blank
      echo "Blank COSMOS_DB_ENDPOINT. Aborting..."
      exit
   else
      echo "COSMOS_DB_ENDPOINT=$COSMOS_DB_ENDPOINT"
         # Example: https://aci-cosmos-db-29776.documents.azure.com:443/
   fi

# Get the Azure Cosmos DB connection key:
COSMOS_DB_MASTERKEY=$(az cosmosdb list-keys \
  --resource-group $RES_GROUP \
  --name $COSMOS_DB_NAME \
  --query primaryMasterKey \
  --output tsv) 
   # Exit if blank
   if ! [[ -z "${COSMOS_DB_MASTERKEY// }" ]]; then  #it's blank
      echo "Blank COSMOS_DB_MASTERKEY. Aborting..."
      exit
   else
      echo "COSMOS_DB_MASTERKEY=$COSMOS_DB_MASTERKEY"
         # Example: ...==
   fi

# Deploy a container that works with the database created above:
az container create \
  --resource-group $RES_GROUP \
  --name aci-demo-secure \
  --image microsoft/azure-vote-front:cosmosdb \
  --ip-address Public \
  --location eastus \
  --secure-environment-variables \
    COSMOS_DB_ENDPOINT=$COSMOS_DB_ENDPOINT \
    COSMOS_DB_MASTERKEY=$COSMOS_DB_MASTERKEY
# TODO: Exit if JSON returned does not contain message": "Started container",

# Get container's public IP address:
IP_ADDRESS=$(az container show \
  --resource-group $RES_GROUP \
  --name aci-demo-secure \
  --query ipAddress.ip \
  --output tsv)
echo "IP_ADDRESS=$IP_ADDRESS"
   # Example: ...==
   # Example: 52.151.246.191

# Get container's environment variables:
RESULT_JSON=$(az container show \
  --resource-group $RES_GROUP \
  --name aci-demo-secure \
  --query containers[0].environmentVariables )
echo "RESULT_JSON=$RESULT_JSON"
   # Resoponse contains:
   # "name": "COSMOS_DB_ENDPOINT",
   #    "value": "https://aci-cosmos-db-3564.documents.azure.com:443/"
   #  "name": "COSMOS_DB_MASTERKEY",
   # "value": "V6KNYCp13FjisvUMfV8gnvCY77wXtYcKVz4SheN2Mtu0zj935gWmhedVEzUJSq44dqqLdhbzaAQSJ7xsPrg6YQ=="


# Verify web page HTML:
curl $IP_ADDRESS
   # Should contain <title>Azure Voting App</title>


############################

# Create an Azure file share
az storage account create \
  --resource-group $RES_GROUP \
  --name $STORAGE_ACCOUNT_NAME \
  --sku Standard_LRS \
  --location $ACR_LOCATION
# JSON

# Create storage account:
export AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string \
  --resource-group $RES_GROUP \
  --name $STORAGE_ACCOUNT_NAME \
  --output tsv)
echo "AZURE_STORAGE_CONNECTION_STRING=$AZURE_STORAGE_CONNECTION_STRING"


# Create a file share:
az storage share create --name $FILE_SHARE_NAME
   # Response should ccontain ""created": true"

# get the storage account key:
STORAGE_ACCT_KEY=$(az storage account keys list \
  --resource-group $RES_GROUP \
  --account-name $STORAGE_ACCOUNT_NAME \
  --query "[0].value" \
  --output tsv)
   echo "STORAGE_ACCT_KEY=$STORAGE_ACCT_KEY"

# Deploy a container and mount the file share:
az container create \
  --resource-group $RES_GROUP \
  --name aci-demo-files \
  --image microsoft/aci-hellofiles \
  --location $ACR_LOCATION \
  --ports 80 \
  --ip-address Public \
  --azure-file-volume-account-name $STORAGE_ACCOUNT_NAME \
  --azure-file-volume-account-key $STORAGE_KEY \
  --azure-file-volume-share-name aci-share-demo \
  --azure-file-volume-mount-path /aci/logs/
   # JSON response should contain "provisioningState": "Succeeded",

# Get public IP address:
IP_ADDRESS=$(az container show \
  --resource-group $RES_GROUP \
  --name aci-demo-files \
  --query ipAddress.ip \
  --output tsv )

curl $IP_ADDRESS
   # HTML should contain  <title>Azure Files and Azure Container Instances</title>


# display the files that are contained in your file share:
az storage file list -s aci-share-demo -o table   

# download a file:
az storage file download -s aci-share-demo -p *



############################

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

# Replicate a registry to multiple locations:
az acr replication create --registry $ACR_NAME \
   --location $ACR_LOCATION2

# $etrieve all container image replicas created:
az acr replication list --registry $ACR_NAME \
   --output table


# Based on https://docs.microsoft.com/en-us/learn/modules/run-docker-with-azure-container-instances/2-run-aci
# Define a DNS name to expose container to the Internet, so it must be unique.
DNS_NAME_LABEL="aci-demo-$RANDOM"
echo "DNS_NAME_LABEL=$DNS_NAME_LABEL"  # example: aci-demo-7214

#
az container create \
  --resource-group $RES_GROUP \
  --name mycontainer \
  --image microsoft/aci-helloworld \
  --ports 80 \
  --dns-name-label $DNS_NAME_LABEL \
  --location $ACR_LOCATION

# TODO: Wait a few seconds:

# Check status:
az container show \
  --resource-group $RES_GROUP \
  --name mycontainer \
  --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" \
  --out table

   # FQDN                                            ProvisioningState
   # ----------------------------------------------  -------------------
   # aci-demo-7214.southcentralus.azurecontainer.io  Succeeded

   #  "FQDN": "aci-demo-7214.southcentralus.azurecontainer.io",
   #  "ProvisioningState": "Succeeded"

# TODO: curl 
#  <title>Welcome to Azure Container Instances!</title>

# Run a container to completion:
az container create \
  --resource-group $RES_GROUP \
  --name mycontainer-restart-demo \
  --image microsoft/aci-wordcount:latest \
  --restart-policy OnFailure \
  --location $ACR_LOCATION

az container show \
  --resource-group $RES_GROUP \
  --name mycontainer-restart-demo \
  --query containers[0].instanceView.currentState.state
   # Response: "Terminated"

CONTAINER_ID=$(az container show \
  --resource-group $RES_GROUP \
  --name mycontainer \
  --query id \
  --output tsv)
echo "CONTAINER_ID=$CONTAINER_ID"  # example: /subscriptions/0e5c0618-4df9-4b9d-97b2-5f46d875fcfa/resourceGroups/b5cb3c0d-4813-4932-8929-031ff63e5846/providers/Microsoft.ContainerInstance/containerGroups/mycontainer

# Get metrics CPUUsage :
az monitor metrics list \
  --resource $CONTAINER_ID \
  --metric CPUUsage \
  --output table
# 2019-04-16 23:42:00  CPU Usage
# BLAH: Where is the number (Average)?


az monitor metrics list \
  --resource $CONTAINER_ID \
  --metric MemoryUsage \
  --output table

############################

# View container's logs:
az container logs \
  --resource-group $RES_GROUP \
  --name mycontainer-restart-demo

# Get container events:
az container attach \
  --resource-group $RES_GROUP \
  --name mycontainer
# Enter Ctrl+C to disconnect from your attached container.

# Execute a command in your container:
az container exec \
  --resource-group $RES_GROUP \
  --name mycontainer \
  --exec-command /bin/sh
# In the "#" that appears, type bash commands such as ls, whoami, date
   # Press Enter twice
# Exit

############################

az group delete --resource-group $RES_GROUP
az ad sp delete --id http://$ACR_NAME-pull
