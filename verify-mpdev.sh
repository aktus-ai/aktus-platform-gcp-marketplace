#!/bin/bash
set -e

# Script for verifying GCP Marketplace deployment with mpdev

echo "Starting GCP Marketplace verification..."

# Step 1: Verify schema and required files
echo "Step 1: Verifying schema..."
mpdev verify

# Step 2: Build the deployer container and verify it
echo "Step 2: Building and verifying deployer..."
mpdev presubmit

# Get deployer image details from build-deployer.sh
REGISTRY=us-docker.pkg.dev/aktus-ai-platform-public/aktus-platform-marketplace
VERSION=$(grep 'publishedVersion:' schema.yaml | cut -d'"' -f2)
DEPLOYER_IMAGE="$REGISTRY/deployer:$VERSION"

# Step 3: Run a test deployment
echo "Step 3: Running test deployment..."
mpdev install \
  --deployer="$DEPLOYER_IMAGE" \
  --parameters='{"name": "aktus-test", "namespace": "test-ns", "serviceAccount.name": "aktus-test-sa"}'

echo "Verification completed." 