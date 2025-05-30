# Cluster Setup

# Step 1: Cluster Setup & Identity Configuration

This guide covers the complete infrastructure setup and identity management for deploying Aktus AI Platform on Google Kubernetes Engine (GKE).

## 🎥 Video Guide

📹 **[Watch Step 1 Installation Video](../videos/step1-cluster-setup.md)**

---

## Prerequisites

- Google Cloud Project with billing enabled
- Google Cloud SDK (`gcloud`) installed and configured
- `kubectl` command-line tool installed
- Project Owner or sufficient IAM permissions

---

## Setup Overview

Step 1 includes:
1. ✅ Create GKE Cluster
2. ✅ Enable Workload Identity
3. ✅ Connect to Cluster
4. ✅ Enable GCS Fuse CSI Driver
5. ✅ Create Service Account
6. ✅ Create Kubernetes Namespace
7. ✅ Bind Service Account with Workload Identity
8. ✅ Grant Storage Object User Role

---

## Detailed Instructions

### 1. Create GKE Cluster

Create a GKE cluster with the required specifications:

```bash
# Set your project variables
export PROJECT_ID="your-project-id"
export CLUSTER_NAME="aktus-ai-cluster"
export REGION="us-central1"  # Choose your preferred region
export ZONE="us-central1-a"  # Choose your preferred zone

# Create the cluster with required specifications
gcloud container clusters create $CLUSTER_NAME \
  --project=$PROJECT_ID \
  --zone=$ZONE \
  --machine-type=e2-standard-16 \
  --num-nodes=3 \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=5 \
  --enable-autorepair \
  --enable-autoupgrade \
  --workload-pool=$PROJECT_ID.svc.id.goog \
  --addons=GcsFuseCsiDriver
```

### 2. Add GPU Node Pool (for Inference Service)

Add a GPU node pool for ML inference:

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

### 3. Connect to Cluster

Get cluster credentials and set up kubectl context:

```bash
gcloud container clusters get-credentials $CLUSTER_NAME \
  --region $REGION \
  --project $PROJECT_ID
```

Verify connection:

```bash
kubectl cluster-info
kubectl get nodes
```

### 4. Enable GCS Fuse CSI Driver

Enable the GCS Fuse CSI driver on your cluster:

```bash
gcloud container clusters update $CLUSTER_NAME \
  --update-addons GcsFuseCsiDriver=ENABLED \
  --location=$REGION
```

Update node pool to support Workload Identity:

```bash
# Get your node pool name
export NODE_POOL_NAME=$(gcloud container node-pools list --cluster=$CLUSTER_NAME --location=$REGION --format="value(name)" | head -1)

gcloud container node-pools update $NODE_POOL_NAME \
  --cluster=$CLUSTER_NAME \
  --location=$REGION \
  --workload-metadata=GKE_METADATA
```

### 5. Create Service Account

Create a Google Cloud service account with required permissions:

```bash
# Set service account variables
export SERVICE_ACCOUNT_NAME="aktus-ai-platform-sa"
export SERVICE_ACCOUNT_EMAIL="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

# Create the service account
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --display-name="Aktus AI Platform Service Account" \
  --description="Service account for Aktus AI Platform GCP Marketplace deployment"

# Grant Storage Admin role to the service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/storage.admin"

# Grant additional required roles
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/monitoring.viewer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/logging.viewer"
```

### 6. Create Kubernetes Namespace

Create the namespace where Aktus AI Platform will be deployed:

```bash
export NAMESPACE="aktus-platform"

kubectl create namespace $NAMESPACE
```

### 7. Bind Service Account with Workload Identity

Configure Workload Identity to allow Kubernetes service accounts to act as Google service accounts:

```bash
# Get your project number
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

# Bind the Google service account to the Kubernetes service account
gcloud iam service-accounts add-iam-policy-binding $SERVICE_ACCOUNT_EMAIL \
  --role="roles/iam.workloadIdentityUser" \
  --member="principal://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$PROJECT_ID.svc.id.goog/subject/ns/$NAMESPACE/sa/aktus-ai-platform-marketplace-serviceaccount"
```

### 8. Grant Storage Object User Role

Grant the required storage permissions for GCS bucket access:

```bash
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="principal://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$PROJECT_ID.svc.id.goog/subject/ns/$NAMESPACE/sa/aktus-ai-platform-marketplace-serviceaccount" \
  --role="roles/storage.objectUser"
```

---

## Verification

Verify your setup is complete:

### Check Cluster Status

```bash
kubectl get nodes
kubectl get namespaces
```

### Verify Workload Identity

```bash
kubectl describe serviceaccount aktus-ai-platform-marketplace-serviceaccount -n $NAMESPACE
```

### Check GCS Fuse CSI Driver

```bash
kubectl get pods -n gke-gcs-fuse-csi-driver
```

---

## Environment Variables Summary

Save these variables for use in subsequent steps:

```bash
# Copy these values for Step 2 and Step 3
echo "PROJECT_ID: $PROJECT_ID"
echo "CLUSTER_NAME: $CLUSTER_NAME"
echo "REGION: $REGION"
echo "NAMESPACE: $NAMESPACE"
echo "SERVICE_ACCOUNT_EMAIL: $SERVICE_ACCOUNT_EMAIL"
```

---

## Troubleshooting

### Common Issues

**Issue:** Permission denied errors  
**Solution:** Ensure you have Project Owner role or these specific permissions:
- `container.clusters.create`
- `iam.serviceAccounts.create`
- `resourcemanager.projects.setIamPolicy`

**Issue:** Workload Identity binding fails  
**Solution:** 
1. Verify project number is correct
2. Ensure cluster has Workload Identity enabled
3. Check service account exists

**Issue:** GCS Fuse CSI Driver not available  
**Solution:**
1. Ensure your cluster version supports GCS Fuse CSI Driver (GKE 1.27+)
2. Verify the driver is enabled: `gcloud container clusters describe $CLUSTER_NAME --location=$REGION`

---

## Next Steps

After completing Step 1, proceed to:

📍 **[Step 2: Network Configuration](network-configuration.md)** - Create static IP addresses

---

## Additional Resources

- [GKE Workload Identity Documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)
- [GCS Fuse CSI Driver Documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/cloud-storage-fuse-csi-driver)
- [Creating GKE Clusters](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-zonal-cluster)