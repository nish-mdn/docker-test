#!/bin/bash
set -e

REPO_URI=177701659471.dkr.ecr.us-east-1.amazonaws.com/mdn-docker-repo

# echo "Stopping old container..."
# docker stop rails-app || true
# docker rm rails-app || true

echo "Pulling latest image..."
aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS --password-stdin $REPO_URI
docker pull $REPO_URI:latest

echo "Starting new container..."
#docker run -d --name myapp -p 80:3000 $REPO_URI:latest
docker run -d  --rm --name rails-app -p 3000:3000 --link db:db -e DB_HOST=db $REPO_URI:latest
