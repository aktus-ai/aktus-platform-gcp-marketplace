set -e 

REGISTRY=us-docker.pkg.dev/aktus-ai-platform-public/aktus-platform-marketplace

if [ -z "$APP_NAME" ]; then
  APP_NAME="aktus-ai-platform"
fi

if [ -z "$MARKETPLACE_TOOLS_TAG" ]; then
  MARKETPLACE_TOOLS_TAG=latest
fi

VERSION=$(grep 'publishedVersion:' schema.yaml | cut -d'"' -f2)
if [ -z "$VERSION" ]; then
  echo "Error: Unable to parse version from schema.yaml"
  exit 1
fi

TRACK=${VERSION%.*}

DEPLOYER_IMAGE="$REGISTRY/deployer:$VERSION"
DEPLOYER_TRACK_IMAGE="$REGISTRY/deployer:$TRACK"
echo "Building $DEPLOYER_IMAGE and $DEPLOYER_TRACK_IMAGE"

(cd chart/aktus-ai-platform && helm dependency update)

docker buildx build --platform linux/amd64,linux/arm64 \
             --build-arg REGISTRY="$REGISTRY" \
             --build-arg TAG="$VERSION" \
             --build-arg MARKETPLACE_TOOLS_TAG="$MARKETPLACE_TOOLS_TAG" \
             --tag "$DEPLOYER_IMAGE" \
             --tag "$DEPLOYER_TRACK_IMAGE" \
             --push \
             .

echo "Images built: $DEPLOYER_IMAGE and $DEPLOYER_TRACK_IMAGE"

if [ -n "$PUSH_IMAGE" ]; then
  echo "Pushing images to registry..."
  docker push "$DEPLOYER_IMAGE"
  docker push "$DEPLOYER_TRACK_IMAGE"
  echo "Images pushed successfully!"
fi


if [ -n "$VERIFY" ]; then
  echo "Running verification..."
  mpdev /scripts/verify --deployer="$DEPLOYER_IMAGE"
  echo "Verification completed!"
fi


if [ -n "$DEPLOY" ]; then
  echo "Running test deployment..."
  
  kubectl get namespace test-ns > /dev/null 2>&1 || kubectl create namespace test-ns
  
  mpdev install \
    --deployer="$DEPLOYER_IMAGE" \
    --parameters='{"name": "aktus-test", "namespace": "test-ns", "serviceAccount": "aktus-ai-platform-sa"}'
  echo "Test deployment completed!"
fi

echo "Done!"