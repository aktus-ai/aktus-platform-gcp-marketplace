#!/bin/bash
set -e

# This script builds and annotates the GCP Marketplace deployer image in one step
REGISTRY=${REGISTRY:-gcr.io/aktus-ai-platform-public}
VERSION=$(grep 'publishedVersion:' schema.yaml | cut -d'"' -f2)
if [ -z "$VERSION" ]; then
  echo "Error: Unable to parse version from schema.yaml"
  exit 1
fi
TRACK=${VERSION%.*}
DEPLOYER_IMAGE="$REGISTRY/aktus-platform-marketplace/deployer:$VERSION"
DEPLOYER_TRACK_IMAGE="$REGISTRY/aktus-platform-marketplace/deployer:$TRACK"
ANNOTATION_KEY="com.googleapis.cloudmarketplace.product.service.name"
ANNOTATION_VALUE="services/aktus-ai-platform.endpoints.aktus-ai-platform-public.cloud.goog"

echo "Configuring docker to authenticate with Artifact Registry..."
gcloud auth configure-docker "${REGISTRY%%/*}" --quiet

echo "Target Deployer Image: $DEPLOYER_IMAGE (Track: $TRACK)"
echo "Updating Helm dependencies..."
(cd chart/aktus-ai-platform && helm dependency update)

# Create a temporary Dockerfile with all necessary annotations
echo "Creating Dockerfile with annotations..."
cat > Dockerfile.deployer << EOF
FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm/onbuild:latest

# Copy marketplace annotations yaml
COPY marketplace-annotations.yaml /data/marketplace-annotations.yaml

# Add all required annotations that GCP Marketplace might look for
LABEL com.googleapis.cloudmarketplace.product.service.name="$ANNOTATION_VALUE"
LABEL com.google.cloudmarketplace.service.endpoint="$ANNOTATION_VALUE"
LABEL com.google.cloud.marketplace.service.endpoint="$ANNOTATION_VALUE"
LABEL com.google.cloud.marketplace.solution-version="$VERSION"
LABEL com.google.cloud.marketplace.partner-id="YL8mwhgO2T"
LABEL com.google.cloud.marketplace.solution-id="aktus-ai-platform"
LABEL maintainer="Aktus AI <support@aktus.ai>"

ENV WAIT_FOR_READY_TIMEOUT=1800
ENV TESTER_TIMEOUT=1800
EOF

# Create the marketplace annotations file
echo "Creating marketplace-annotations.yaml..."
cat > marketplace-annotations.yaml << EOF
publishedVersion: "$VERSION"
publishedVersionMetadata:
  releaseNote: >-
    Initial release of Aktus AI Platform.

required:
  serviceNamespace: "$ANNOTATION_VALUE"
  partnerID: "YL8mwhgO2T"
  solutionID: "aktus-ai-platform"

# Add annotations explicitly
annotations:
  com.googleapis.cloudmarketplace.product.service.name: "$ANNOTATION_VALUE"
  com.google.cloudmarketplace.service.endpoint: "$ANNOTATION_VALUE"
  com.google.cloud.marketplace.service.endpoint: "$ANNOTATION_VALUE"
EOF

# Enable experimental features for Docker
export DOCKER_CLI_EXPERIMENTAL=enabled
export DOCKER_BUILDKIT=1

# Explicitly pull the base image first
echo "Pulling base image..."
docker pull gcr.io/cloud-marketplace-tools/k8s/deployer_helm/onbuild:latest || { echo "Failed to pull base image"; exit 1; }

# Build and push the image with the version tag (1.0.0)
echo "Building and pushing version-tagged image..."
docker buildx build --platform linux/amd64 \
    --provenance=false \
    --build-arg REGISTRY="$REGISTRY" \
    --build-arg TAG="$VERSION" \
    --output type=registry,name="$DEPLOYER_IMAGE" \
    --annotation "$ANNOTATION_KEY=$ANNOTATION_VALUE" \
    -f Dockerfile.deployer \
    .

# Get the digest of the pushed image
DIGEST=$(docker buildx imagetools inspect "$DEPLOYER_IMAGE" --raw | grep -o '"digest": "sha256:[a-f0-9]*"' | head -1 | sed 's/"digest": "sha256:\([a-f0-9]*\)"/\1/')
echo "Image digest: sha256:$DIGEST"

# Tag the track version with docker tag and push (to ensure they're identical)
echo "Creating track tag using docker CLI..."
DIGESTED_IMAGE="$REGISTRY/aktus-platform-marketplace/deployer@sha256:$DIGEST"

# Pull the digested image
docker pull "$DIGESTED_IMAGE"

# Tag it as the track version
docker tag "$DIGESTED_IMAGE" "$DEPLOYER_TRACK_IMAGE"

# Push the track tag
docker push "$DEPLOYER_TRACK_IMAGE"

echo "Verifying images..."
echo "Version tag ($VERSION):"
docker buildx imagetools inspect "$DEPLOYER_IMAGE" --raw | grep -A 3 annotations || echo "No annotations found"

echo "Track tag ($TRACK):"
docker buildx imagetools inspect "$DEPLOYER_TRACK_IMAGE" --raw | grep -A 3 annotations || echo "No annotations found"

# Verify digests match
VERSION_DIGEST=$(docker buildx imagetools inspect "$DEPLOYER_IMAGE" --raw | grep -o '"digest": "sha256:[a-f0-9]*"' | head -1)
TRACK_DIGEST=$(docker buildx imagetools inspect "$DEPLOYER_TRACK_IMAGE" --raw | grep -o '"digest": "sha256:[a-f0-9]*"' | head -1)

echo "Version tag digest: $VERSION_DIGEST"
echo "Track tag digest: $TRACK_DIGEST"

if [ "$VERSION_DIGEST" = "$TRACK_DIGEST" ]; then
  echo "✅ Success! Both tags point to the same image."
else
  echo "❌ Warning: Tags have different digests."
  echo "This might cause issues with GCP Marketplace which expects both tags to be identical."
fi

echo "Successfully built and annotated deployer image:"
echo "- Version tag: $DEPLOYER_IMAGE"
echo "- Track tag: $DEPLOYER_TRACK_IMAGE"
echo ""
echo "These images are ready for GCP Marketplace submission."

# Clean up
rm -f Dockerfile.deployer marketplace-annotations.yaml 