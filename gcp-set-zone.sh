# This sets the default zone on Google Compute Cloud.
# Run this with command:
# bash <(curl -O https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/gcp-set-zone.sh)
# Described in https://wilsonmar.github.io/gcp
# Environment variables are set so other scripts can determine what zone and region was set.
# The variables were in Google documentation, so I don't what side affects there may be.

   export CLOUDSDK_COMPUTE_ZONE=us-central1-f
   export CLOUDSDK_COMPUTE_REGION=us-central1 
   echo $CLOUDSDK_COMPUTE_ZONE
   echo $CLOUDSDK_COMPUTE_REGION

gcloud config set compute/zone ${CLOUDSDK_COMPUTE_ZONE}
