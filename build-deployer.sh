#!/bin/bash
set -e

REGISTRY=${REGISTRY:-us-docker.pkg.dev/aktus-ai-platform-public/aktus-platform-marketplace}
APP_NAME=${APP_NAME:-aktus-ai-platform}
MARKETPLACE_TOOLS_TAG=${MARKETPLACE_TOOLS_TAG:-latest}
PARAMS_JSON="" 
DO_PUSH=false
DO_VERIFY=false
DO_INSTALL=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --push) DO_PUSH=true ;;
        --verify) DO_VERIFY=true ;;
        --install) DO_INSTALL=true ;;
        --parameters) PARAMS_JSON="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "Configuring docker to authenticate with Artifact Registry..."
gcloud auth configure-docker "${REGISTRY%%/*}" --quiet
echo "Reading version from schema.yaml..."
VERSION=$(grep 'publishedVersion:' schema.yaml | cut -d'"' -f2)
if [ -z "$VERSION" ]; then
  echo "Error: Unable to parse version from schema.yaml"
  exit 1
fi
TRACK=${VERSION%.*}
DEPLOYER_IMAGE="$REGISTRY/deployer:$VERSION"
DEPLOYER_TRACK_IMAGE="$REGISTRY/deployer:$TRACK"
echo "Target Deployer Image: $DEPLOYER_IMAGE (Track: $TRACK)"
echo "Updating Helm dependencies..."
(cd chart/aktus-ai-platform && helm dependency update)
echo "Building deployer image..."
docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg REGISTRY="$REGISTRY" \
             --build-arg TAG="$VERSION" \
             --build-arg MARKETPLACE_TOOLS_TAG="$MARKETPLACE_TOOLS_TAG" \
             --tag "$DEPLOYER_IMAGE" \
             --tag "$DEPLOYER_TRACK_IMAGE" \
             --load \
             . 

echo "Image built: $DEPLOYER_IMAGE"

if [ "$DO_PUSH" = true ]; then
  echo "Pushing images to registry..."
  docker push "$DEPLOYER_IMAGE"
  docker push "$DEPLOYER_TRACK_IMAGE"
  echo "Images pushed successfully!"
fi

if [ "$DO_VERIFY" = true ]; then
  echo "Running mpdev verify..."
  mpdev verify --deployer="$DEPLOYER_IMAGE"
  echo "Verification attempt finished."
fi

if [ "$DO_INSTALL" = true ]; then
  echo "Running mpdev install..."
  if [ -n "$PARAMS_JSON" ]; then
      echo "Using parameters: $PARAMS_JSON"
      mpdev install --deployer="$DEPLOYER_IMAGE" --parameters="$PARAMS_JSON"
  else
      echo "No parameters specified, using defaults from schema.yaml..."
      mpdev install --deployer="$DEPLOYER_IMAGE"
  fi
  echo "Installation attempt finished."
fi

echo "Script finished."