# Within Google Cloud, setup using Docker an instance of a "hello-world" NodeJS sample server.
# 

# Install curl if it's not already:
# sudo apt-get install curl

# Download Dockerfile
curl -o simple-server.js https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/NodeJs/Dockerfile

docker build -t gcr.io/${DEVSHELL_PROJECT_ID}/hello-node:v1 .
