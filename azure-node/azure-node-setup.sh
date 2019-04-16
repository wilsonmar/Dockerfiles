#!/bin/bash
# azure-node-setup.sh
# Run this from any directory:
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/azure-node/azure-node-setup.sh)"

COSMOS_DB_NAME="aci-cosmos-db-$RANDOM"
echo "COSMOS_DB_NAME=$COSMOS_DB_NAME"

RESULT1=$RANDOM
echo "RESULT1=aci-cosmos-db-$RESULT1"

RESULT2=$(RANDOM)
echo "RESULT2=$RESULT2"

RESULT3=RANDOM
echo "RESULT3=$RESULT3"

RESULT4="$(RANDOM)"
echo "RESULT4=$RESULT4"
