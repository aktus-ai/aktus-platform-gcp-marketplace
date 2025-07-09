## 🎥 Related Videos
- **[Create_Cluster](https://drive.google.com/file/d/1jN72wLWiD_R-nyb-ry0W6oLpD9LY16Rv/view?usp=sharing)** `30 min`
- **[GCSFuse_Cluster](https://drive.google.com/file/d/19wrUxLJXTvxQqUjrmbE3bfO3EHhNuvZh/view?usp=sharing)** `30 min`
- **[GCSFuse_Node](https://drive.google.com/file/d/1z2T3Al1JHzTSJB_VwrAz7C1XL636UfQw/view?usp=sharing)** `10 min`

---

## 📋 Prerequisites

- A Google Cloud project with billing enabled
- Access to [Google Cloud Shell](https://console.cloud.google.com/)

---
## ☁️ GKE Cluster Creation Instructions (Pre-Deployment)

Follow these steps to create and configure your Kubernetes cluster using the Google Cloud Console:

---

### 1. Open Kubernetes Engine

- Navigate to the **Kubernetes Engine** section in your Google Cloud Console.

---

### 2. Create a Cluster

- Scroll down and click **“Create Cluster”**.
- Choose **“Standard”** mode and click **“Configure”**.

---

### 3. Name Your Cluster

- Enter `aktus-marketplace-cluster` as the cluster name.

---

### 🛠️ Configure the Default Node Pool (`non-gpu-pool`)

#### 4. Access Node Pools

- In the left-hand sidebar, click **“Node Pools”**.
- Click on the **default** pool.

#### 5. Rename Default Pool

- Rename it to: `non-gpu-pool`.

#### 6. Set Node Count

- Set the number of nodes to **3** (minimum required for the application).
- You may increase this based on expected load.

#### 7. Specify Node Locations

- Scroll down to **“Specify node locations”** and enable it to reveal region options.
- Select your preferred region (e.g., `us-central1-a`).

> ⚠️ **Note**: If you select multiple regions, the number of nodes is applied **per region**:
> - 3 nodes × 2 regions = 6 nodes  
> - 3 nodes × 3 regions = 9 nodes

#### 8. Set Machine Type

- Under `non-gpu-pool`, click **“Nodes”** in the sidebar.
- Scroll to **“Machine type”**, click to change.
- Select:
  - **Category**: `Standard`
  - **Machine Type**: `e2-standard-16`

> These specs are the minimum recommended for proper platform performance.

---

### ⚡ Add and Configure GPU Node Pool (`gpu-pool`)

#### 9. Add New Pool

- Scroll to the top and click **“Add Node Pool”**.

#### 10. Rename New Pool

- In the sidebar, click the new pool (e.g., `pool-1`) and rename it to: `gpu-pool`.

#### 11. Set Node Count

- Set the number of nodes to **1**.

#### 12. Specify Node Locations

- Enable **“Specify node locations”** and select the **same region(s)** as used in `non-gpu-pool`.

#### 13. Set GPU Configuration

- Under `gpu-pool`, click **“Nodes”** in the sidebar.
- Change the machine configuration to:
  - **GPU Type**: `NVIDIA A100 40GB`
  - **Number of GPUs**: `1`

- Check the box for **“Google-managed”** driver management.

---

### 🔐 Enable Workload Identity

#### 14. Enable Security Setting

- In the cluster sidebar, go to **“Security”**.
- Enable **Workload Identity**.

---

### 15. Create the Cluster

- Click **“Create”** at the bottom of the page.

> ⏳ **Note**: Cluster provisioning may take **20–30 minutes** to complete, after which you can navigate back to the Aktus Platform deployment page.

---


## 🛠️ CLI Deployment Commands (Google Cloud Shell)

These commands are intended to be run **after cluster creation** directly in **Google Cloud Shell**, which comes pre-authenticated and pre-configured with the `gcloud` CLI and `kubectl`.

Before proceeding, ensure you're operating within the correct project. You can confirm or change the active project with:

```bash
gcloud config set project <project-id>
```
## ⚙️ Deployment Steps

### 1. Get GKE Cluster Credentials

```bash
gcloud container clusters get-credentials <cluster-name> \
  --region <region> \
  --project <project-id>
```
- **Purpose**: Connects your local `kubectl` context to the specified GKE cluster.
- **<region>**: e.g., `us-central1`
- **<project-id>**: Found in the top-left corner of the GCP Console.

### 2. Enable GCS Fuse CSI Driver on the Cluster
```bash
gcloud container clusters update <cluster-name> \
  --update-addons GcsFuseCsiDriver=ENABLED \
  --location=<region>
```
- **Purpose**: Enables the GCS Fuse CSI driver to support GCS bucket mounting via Kubernetes.

### 3. Update Node Pool to Support Workload Identity
```bash
gcloud container node-pools update <pool-name> \
  --cluster=<cluster-name> \
  --location=<region> \
  --workload-metadata=GKE_METADATA
```
- **Purpose**: Configures nodes to support Workload Identity for secure service account access. Done twice, one for each node pool -- once for non-gpu-pool, once again for gpu-pool.

### 4. Create a Kubernetes Namespace
```bash
kubectl create namespace <namespace>
```
- **Purpose**: Sets up a dedicated namespace for your application resources.

### 5. Bind IAM Policy to GCP Service Account
```bash
gcloud iam service-accounts add-iam-policy-binding <service-account-email> \
  --role="roles/iam.workloadIdentityUser" \
  --member="principal://iam.googleapis.com/projects/<project-number>/locations/global/workloadIdentityPools/<project-id>.svc.id.goog/subject/ns/<namespace>/sa/<your-application-name>-serviceaccount"
```
- **Purpose**: Grants the Kubernetes service account permission to impersonate the GCP IAM service account.
- **<service-account-email>**: e.g., `my-app-sa@my-project.iam.gserviceaccount.com`
- **<project-number>**: Found under **Project Settings** (top-right corner menu in the GCP Console).
- **<your-application-name>**: Your application’s name (used in the Kubernetes service account name).

### 6. Grant Storage Access to Kubernetes Service Account
```bash
gcloud projects add-iam-policy-binding <project-id> \
  --member="principal://iam.googleapis.com/projects/<project-number>/locations/global/workloadIdentityPools/<project-id>.svc.id.goog/subject/ns/<namespace>/sa/<your-application-name>-serviceaccount" \
  --role="roles/storage.objectUser"
```
- **Purpose**: Grants the Kubernetes service account permission to access GCS buckets as a Storage Object User.

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
