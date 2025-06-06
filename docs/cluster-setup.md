# Cluster Setup
> **Step 1:** Create GKE cluster and configure Workload Identity for Aktus AI Platform

---

## 🎥 Related Videos
- **[Create_Cluster](https://drive.google.com/file/d/1jN72wLWiD_R-nyb-ry0W6oLpD9LY16Rv/view?usp=sharing)** `30 min`
- **[GCSFuse_Cluster](https://drive.google.com/file/d/19wrUxLJXTvxQqUjrmbE3bfO3EHhNuvZh/view?usp=sharing)** `30 min`
- **[GCSFuse_Node](https://drive.google.com/file/d/1z2T3Al1JHzTSJB_VwrAz7C1XL636UfQw/view?usp=sharing)** `10 min`

---

## 📋 Prerequisites

- Google Cloud Project with billing enabled
- Google Cloud SDK installed
- Project Owner permissions

---

## ⚡ Quick Setup

### Environment Variables
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

### Enable GCSFuse CSI Driver
```bash
gcloud container clusters update $CLUSTER_NAME \
  --update-addons GcsFuseCsiDriver=ENABLED \
  --location=$REGION
```

### Update Node Pools for GCSFuse
> **Note:** Run this command for each node pool created earlier

```bash
# Update default node pool
gcloud container node-pools update default-pool \
  --cluster=$CLUSTER_NAME \
  --location=$REGION \
  --workload-metadata=GKE_METADATA

# Update GPU node pool
gcloud container node-pools update gpu-pool \
  --cluster=$CLUSTER_NAME \
  --location=$REGION \
  --workload-metadata=GKE_METADATA
```

---

## 🔐 Identity Configuration

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

**NOTE**: The value of `YOUR-APPLICATION-NAME` is the same as the name you chose in Step #1 of the application installation.
```bash
kubectl create namespace $NAMESPACE

export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

gcloud iam service-accounts add-iam-policy-binding $SERVICE_ACCOUNT_EMAIL \
  --role="roles/iam.workloadIdentityUser" \
  --member="principal://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$PROJECT_ID.svc.id.goog/subject/ns/$NAMESPACE/sa/<YOUR-APPLICATION-NAME>-serviceaccount"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="principal://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$PROJECT_ID.svc.id.goog/subject/ns/$NAMESPACE/sa/<YOUR-APPLICATION-NAME>-serviceaccount" \
  --role="roles/storage.objectUser"
```

---

## ✅ Verification

```bash
kubectl get nodes
kubectl get namespace $NAMESPACE
```

---

<div align="center">

**Next Step:** [Network Configuration](network-configuration.md) →

</div>