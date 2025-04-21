#!/bin/bash
set -e

echo "=== Aktus AI Platform Verification Tests ==="
echo "Starting basic connectivity tests..."

# Test PostgreSQL connectivity
if wait-for-it.sh "$POSTGRES_HOST:5432" -t 30; then
  echo "✓ PostgreSQL is reachable"
  
  # Try a basic database query
  PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USER -d postgres -c "\l" > /dev/null
  if [ $? -eq 0 ]; then
    echo "✓ PostgreSQL query successful"
  else
    echo "✗ ERROR: Cannot query PostgreSQL"
    exit 1
  fi
else
  echo "✗ ERROR: Cannot connect to PostgreSQL"
  exit 1
fi

# Test Redis if enabled
if [ "$REDIS_ENABLED" == "true" ]; then
  echo "Testing Redis Connection..."
  if wait-for-it.sh "$REDIS_HOST:6379" -t 15; then
    echo "✓ Redis is reachable"
  else
    echo "✗ ERROR: Cannot connect to Redis"
    exit 1
  fi
fi

# Test RabbitMQ if enabled
if [ "$RABBITMQ_ENABLED" == "true" ]; then
  echo "Testing RabbitMQ Connection..."
  if wait-for-it.sh "$RABBITMQ_HOST:5672" -t 15; then
    echo "✓ RabbitMQ is reachable"
  else
    echo "✗ ERROR: Cannot connect to RabbitMQ"
    exit 1
  fi
fi

# Test Inference Service gRPC endpoint
if [ "$INFERENCE_ENABLED" == "true" ]; then
  echo "Testing Inference Service gRPC Connection..."
  if wait-for-it.sh "$INFERENCE_HOST:50051" -t 30; then
    echo "✓ Inference Service gRPC endpoint is reachable"
    
    # Try a basic health check with grpcurl
    if grpcurl -plaintext $INFERENCE_HOST:50051 list > /dev/null 2>&1; then
      echo "✓ Inference Service gRPC health check successful"
    else
      echo "✗ WARNING: Inference Service gRPC health check failed"
    fi
  else
    echo "✗ ERROR: Cannot connect to Inference Service gRPC endpoint"
    exit 1
  fi
fi

# Test Research Service HTTP endpoint
if [ "$RESEARCH_ENABLED" == "true" ]; then
  echo "Testing Research Service HTTP Connection..."
  if wait-for-it.sh "$RESEARCH_HOST:8080" -t 30; then
    echo "✓ Research Service HTTP endpoint is reachable"
    
    # Try a basic HTTP health check
    if curl -s -o /dev/null -w "%{http_code}" http://$RESEARCH_HOST:8080/health | grep -q 200; then
      echo "✓ Research Service HTTP health check successful"
    else
      echo "✗ WARNING: Research Service HTTP health check failed"
    fi
  else
    echo "✗ ERROR: Cannot connect to Research Service HTTP endpoint"
    exit 1
  fi
fi

# Test UBB Agent if billing is enabled
if [ "$BILLING_ENABLED" == "true" ]; then
  echo "Testing UBB Agent..."
  if wait-for-it.sh "$BILLING_HOST:8090" -t 15; then
    echo "✓ UBB Agent endpoint is reachable"
  else
    echo "✗ WARNING: Cannot connect to UBB Agent"
  fi
fi

# Print summary
echo ""
echo "=== Test Summary ==="
echo "Basic connectivity tests completed successfully."
echo "For a full verification, deploy the application to your GKE cluster."
echo ""

# Tests passed
exit 0