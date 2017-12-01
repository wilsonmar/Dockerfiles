# Within Google Cloud, setup using Docker an instance of a "hello-world" NodeJS sample server.
# bash <(curl -s https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/NodeJs/hello-world-setup.sh)

# Install curl if it's not already:
# sudo apt-get install curl

# Download Dockerfile:
curl -o https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/NodeJs/Dockerfile

# Build "hello-node" image in Google Code Repository:
docker build -t gcr.io/${DEVSHELL_PROJECT_ID}/hello-node:v1 .

