#!/bin/bash
set -e

REPO_URI=177701659471.dkr.ecr.<region>.amazonaws.com/myapp

echo "Stopping old container..."
docker stop myapp || true
docker rm myapp || true

echo "Pulling latest image..."
aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS --password-stdin $REPO_URI
docker pull $REPO_URI:latest

echo "Starting new container..."
docker run -d --name myapp -p 80:3000 $REPO_URI:latest
