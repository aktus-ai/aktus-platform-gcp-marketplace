#!/bin/bash
# Script to build and push the Aktus AI Platform deployer image for GCP Marketplace

set -e

PROJECT_ID="aktus-393100"
VERSION="0.1.0"
TRACK="0.1"
APP_NAME="aktus-platform"

IMAGE_NAME="us-central1-docker.pkg.dev/${PROJECT_ID}/google-marketplace/${APP_NAME}/deployer"

if [ ! -d "chart/aktus-ai-platform" ]; then
  echo "Error: This script must be run from the root of your repository"
  echo "Current directory structure:"
  ls -la
  exit 1
fi

mkdir -p apptest/deployer/manifest

if [ ! -f "apptest/schema.yaml" ]; then
  echo "Error: apptest/schema.yaml not found"
  exit 1
fi

if [ ! -f "apptest/deployer/manifest/tester.yaml" ]; then
  echo "Error: apptest/deployer/manifest/tester.yaml not found"
  exit 1
fi

if [ ! -f "schema.yaml" ]; then
  echo "Error: schema.yaml not found in the current directory"
  exit 1
fi

echo "Building multi-arch deployer image locally: ${IMAGE_NAME}:${TRACK}"
docker buildx build \
  -f ./Dockerfile \
  --platform linux/amd64,linux/arm64 \
  --no-cache \
  --build-arg REGISTRY=us-central1-docker.pkg.dev/${PROJECT_ID}/google-marketplace/${APP_NAME} \
  --build-arg TAG=${VERSION} \
  --tag ${IMAGE_NAME}:${TRACK} \
  --tag ${IMAGE_NAME}:latest \
  --load .

gcloud auth configure-docker us-central1-docker.pkg.dev
echo "Pushing multi-arch image: ${IMAGE_NAME}:${TRACK} and :latest"
docker push ${IMAGE_NAME}:${TRACK}
docker push ${IMAGE_NAME}:latest

echo "Successfully built and pushed multi-arch deployer image: ${IMAGE_NAME}:${TRACK}"
echo ""
echo "To verify your application, run:"
echo "mpdev /scripts/verify --deployer=${IMAGE_NAME}:${TRACK}"
echo ""
echo "To submit this version for review, use Partner Portal and specify:"
echo "Deployer Image: ${IMAGE_NAME}:${TRACK}"