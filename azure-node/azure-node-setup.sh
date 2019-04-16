#!/bin/bash
# azure-node-setup.sh
# Run this from any directory:
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/azure-node/azure-node-setup.sh)"

COSMOS_DB_NAME="aci-cosmos-db-$RANDOM"
echo "COSMOS_DB_NAME=$COSMOS_DB_NAME"

RESULT1=$RANDOM
NAME=$FILENAME'_'$EXTENSION
echo RESULT2='aci-cosmos-db-'$RESULT1
echo "RESULT2=$RESULT2"

RESULT3='aci-cosmos-db-'$RANDOM
echo "RESULT3=$RESULT3"
