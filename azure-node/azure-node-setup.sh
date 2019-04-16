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
ACR_LOCATION="southcentralus"  # eastus, etc.
ACR_LOCATION2="japaneast"

# To create an Azure Container Registry for an app:
#    (A premium registry SKU is needed for geo-replication.
RES_GROUP="e2aa9a5e-9731-4095-a768-ea72a3026c19"
   #RES_GROUP=$ACR_NAME ? in https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task
CONTAINER="helloacrtasks:v1"
echo "RESULT=$RANDOM"
RESULT2=$((1 + RANDOM % 1000))
echo "RESULT2=$RESULT2"
exit

COSMOS_DB_NAME="aci-cosmos-db-$RANDOM"
echo "COSMOS_DB_NAME=$COSMOS_DB_NAME"
exit


#3 Define reusable functions:
function echo_f() {  # echo fancy comment
  local fmt="$1"; shift
  printf "\\n    >>> $fmt\\n" "$@"
}
function echo_c() {  # echo common comment
  local fmt="$1"; shift
  printf "        $fmt\\n" "$@"
}

#4 Collect starting system information and display on console:
TIME_START="$(date -u +%s)"
#FREE_DISKBLOCKS_END=$(df | sed -n -e '2{p;q}' | cut -d' ' -f 6) # no longer works
FREE_DISKBLOCKS_START="$(df -P | awk '{print $4}' | sed -n 2p)"  # e.g. 342771200 from:
   # Filesystem    512-blocks      Used Available Capacity  Mounted on
   # /dev/disk1s1   976490568 611335160 342771200    65%    /
LOG_PREFIX=$(date +%Y-%m-%dT%H:%M:%S%z)-$((1 + RANDOM % 1000))
   # ISO-8601 date plus RANDOM=$((1 + RANDOM % 1000))  # 3 digit random number.
   #  LOGFILE="$0.$LOG_PREFIX.log"
echo_f "STARTING $0 within $PWD"
echo_c "at $LOG_PREFIX with $FREE_DISKBLOCKS_START blocks free ..."

#########


# Create Cosmos (NOSQL) db:
COSMOS_DB_ENDPOINT=$(az cosmosdb create \
  --resource-group ee9ae253-1d6a-4b80-88e7-909c9f403a95 \
  --name $COSMOS_DB_NAME \
  --query documentEndpoint \
  --output tsv)
  # Example: https://aci-cosmos-db-29776.documents.azure.com:443/

# Get the Azure Cosmos DB connection key:
COSMOS_DB_MASTERKEY=$(az cosmosdb list-keys \
  --resource-group ee9ae253-1d6a-4b80-88e7-909c9f403a95 \
  --name $COSMOS_DB_NAME \
  --query primaryMasterKey \
  --output tsv)  


az container create \
  --resource-group ee9ae253-1d6a-4b80-88e7-909c9f403a95 \
  --name aci-demo-secure \
  --image microsoft/azure-vote-front:cosmosdb \
  --ip-address Public \
  --location $ACR_LOCATION \
  --secure-environment-variables \
    COSMOS_DB_ENDPOINT=$COSMOS_DB_ENDPOINT \
    COSMOS_DB_MASTERKEY=$COSMOS_DB_MASTERKEY

# display container's environment variables:
az container show \
  --resource-group ee9ae253-1d6a-4b80-88e7-909c9f403a95 \
  --name aci-demo-secure \
  --query containers[0].environmentVariables

# Get container's public IP address:
az container show \
  --resource-group ee9ae253-1d6a-4b80-88e7-909c9f403a95 \
  --name aci-demo-secure \
  --query ipAddress.ip \
  --output tsv
   # Example: 52.151.246.191


############################

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
  --resource-group ee9ae253-1d6a-4b80-88e7-909c9f403a95 \
  --name mycontainer \
  --image microsoft/aci-helloworld \
  --ports 80 \
  --dns-name-label $DNS_NAME_LABEL \
  --location $ACR_LOCATION

# TODO: Wait a few seconds:

# Check status:
az container show \
  --resource-group ee9ae253-1d6a-4b80-88e7-909c9f403a95 \
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
  --resource-group ee9ae253-1d6a-4b80-88e7-909c9f403a95 \
  --name mycontainer-restart-demo \
  --image microsoft/aci-wordcount:latest \
  --restart-policy OnFailure \
  --location $ACR_LOCATION

az container show \
  --resource-group ee9ae253-1d6a-4b80-88e7-909c9f403a95 \
  --name mycontainer-restart-demo \
  --query containers[0].instanceView.currentState.state
   # Response: "Terminated"

# View container's logs:
az container logs \
  --resource-group ee9ae253-1d6a-4b80-88e7-909c9f403a95 \
  --name mycontainer-restart-demo

az group delete --resource-group $RES_GROUP
az ad sp delete --id http://$ACR_NAME-pull
