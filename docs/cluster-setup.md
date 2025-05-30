# Cluster Setup

# Step 1: Cluster Setup & Identity Configuration

Create GKE cluster and configure Workload Identity for Aktus AI Platform.

## Prerequisites

- Google Cloud Project with billing enabled
- Google Cloud SDK installed
- Project Owner permissions

## Commands

### Environment Setup
```bash
export PROJECT_ID="your-project-id"
export CLUSTER_NAME="aktus-ai-cluster"
export REGION="us-central1"
export ZONE="us-central1-a"
export NAMESPACE="aktus-platform"
```

### Create Cluster
```bash
gcloud container clusters create $CLUSTER_NAME \
  --project=$PROJECT_ID \
  --zone=$ZONE \
  --machine-type=e2-standard-16 \
  --num-nodes=3 \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=5 \
  --workload-pool=$PROJECT_ID.svc.id.goog \
  --enable-ip-alias
```

### Add GPU Node Pool
```bash
gcloud container node-pools create gpu-pool \
  --cluster=$CLUSTER_NAME \
  --zone=$ZONE \
  --machine-type=a2-highgpu-1g \
  --accelerator=type=nvidia-tesla-a100,count=1 \
  --num-nodes=1 \
  --enable-autoscaling \
  --min-nodes=0 \
  --max-nodes=2 \
  --workload-metadata=GKE_METADATA
```

### Connect to Cluster
```bash
gcloud container clusters get-credentials $CLUSTER_NAME \
  --region $REGION \
  --project $PROJECT_ID
```

### Create Service Account
```bash
export SERVICE_ACCOUNT_NAME="aktus-ai-platform-sa"
export SERVICE_ACCOUNT_EMAIL="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --display-name="Aktus AI Platform Service Account"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/storage.admin"
```

### Setup Workload Identity
```bash
kubectl create namespace $NAMESPACE

export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

gcloud iam service-accounts add-iam-policy-binding $SERVICE_ACCOUNT_EMAIL \
  --role="roles/iam.workloadIdentityUser" \
  --member="principal://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$PROJECT_ID.svc.id.goog/subject/ns/$NAMESPACE/sa/aktus-ai-platform-marketplace-serviceaccount"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="principal://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$PROJECT_ID.svc.id.goog/subject/ns/$NAMESPACE/sa/aktus-ai-platform-marketplace-serviceaccount" \
  --role="roles/storage.objectUser"
```

### Verification
```bash
kubectl get nodes
kubectl get namespace $NAMESPACE
```

## Next Steps

📍 **[Step 2: Network Configuration](network-configuration.md)**