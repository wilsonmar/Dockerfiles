# This sets the default zone on Google Compute Cloud.
# Run this with command:
# bash <(curl -s https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/gcp-set-zone.sh)
# Described in https://wilsonmar.github.io/gcp
# This needs to avoid errors when running kubctl commands. such as:
#   ERROR: (gcloud.container.clusters.create) One of [--zone] must be supplied: Please specify zone.
# Environment variables are set so other scripts can determine what zone and region was set.
# This sets a property defined in Google documentation, so I don't what side affects there may be.
# This is used until I can figure out how to access the property in bash scripts.

   export CLOUDSDK_COMPUTE_ZONE=us-central1-f
   export CLOUDSDK_COMPUTE_REGION=us-central1 
   echo $CLOUDSDK_COMPUTE_ZONE
   echo $CLOUDSDK_COMPUTE_REGION

gcloud config set compute/zone ${CLOUDSDK_COMPUTE_ZONE}
