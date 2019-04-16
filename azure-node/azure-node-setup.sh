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
RESULT=RANDOM
echo "RESULT=$RESULT"

RESULT2="$((1 + $RANDOM % 1000))"
echo "RESULT=$RESULT, RESULT2=$RESULT2"
exit

COSMOS_DB_NAME="aci-cosmos-db-$RANDOM"
echo "COSMOS_DB_NAME=$COSMOS_DB_NAME"
exit

