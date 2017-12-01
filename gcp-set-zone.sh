# This sets the default zone on Google Compute Cloud.
# Run this with command:
# bash <(curl -s https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/gcp-set-zone.sh)
# Described in https://wilsonmar.github.io/gcp
# This needs to avoid errors when running kubctl commands. such as:
#   ERROR: (gcloud.container.clusters.create) One of [--zone] must be supplied: Please specify zone.
# Environment variables are set so other scripts can determine what zone and region was set.
# This sets a property defined in Google documentation, so I don't what side affects there may be.
# This is used until I can figure out how to access the property in bash scripts.

   export CLOUDSDK_COMPUTE_ZONE=us-central1-d
   export CLOUDSDK_COMPUTE_REGION=us-central1 
   echo "Setting CLOUDSDK_COMPUTE_ZONE=$CLOUDSDK_COMPUTE_ZONE in CLOUDSDK_COMPUTE_REGION=${CLOUDSDK_COMPUTE_REGION}"

gcloud config set compute/zone ${CLOUDSDK_COMPUTE_ZONE}

# The response is:
# us-central1-f
# us-central1
# WARNING: Property [zone] is overridden by environment setting [CLOUDSDK_COMPUTE_ZONE=us-central1-f]
# Updated property [compute/zone].

# I was hoping this command would expose the zone, but it doesn't:
# gcloud compute project-info describe --project ${DEVSHELL_PROJECT_ID}
