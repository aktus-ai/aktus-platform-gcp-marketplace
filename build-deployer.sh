#!/bin/bash
# Script to build and push the Aktus AI Platform deployer image for GCP Marketplace

set -e

PROJECT_ID="aktus-ai-platform-public"
VERSION="1.0.0"
TRACK="1.0"
APP_NAME="aktus-platform"

IMAGE_NAME="us-docker.pkg.dev/${PROJECT_ID}/aktus-platform-marketplace/deployer"

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

echo "Building multi-arch deployer image locally: ${IMAGE_NAME}:${VERSION}"
docker buildx build \
  -f ./Dockerfile \
  --platform linux/amd64,linux/arm64 \
  --no-cache \
  --build-arg REGISTRY=us-docker.pkg.dev/${PROJECT_ID}/aktus-platform-marketplace/${APP_NAME} \
  --build-arg TAG=${VERSION} \
  --tag ${IMAGE_NAME}:${VERSION} \
  --tag ${IMAGE_NAME}:${TRACK} \
  --load .

gcloud auth configure-docker us-docker.pkg.dev
echo "Pushing multi-arch image: ${IMAGE_NAME}:${VERSION} and :${TRACK}"
docker push ${IMAGE_NAME}:${VERSION}
docker push ${IMAGE_NAME}:${TRACK}

echo "Successfully built and pushed multi-arch deployer image: ${IMAGE_NAME}:${VERSION}"
echo ""
echo "To verify your application, run:"
echo "mpdev /scripts/verify --deployer=${IMAGE_NAME}:${VERSION}"
echo ""
echo "To submit this version for review, use Partner Portal and specify:"
echo "Deployer Image: ${IMAGE_NAME}:${VERSION}"