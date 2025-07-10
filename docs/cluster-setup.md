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

## 🔧 Step 1 (Continued): GCS Fuse Setup

This section covers the post-cluster creation steps to enable GCS Fuse support and set up identity permissions.

---

### 1.1 Connect to the Cluster

Activate **Cloud Shell** in your GCP Console and run:

```bash
gcloud container clusters get-credentials <cluster-name> \
  --region <region> \
  --project <project-id>
```

- `<project-id>`: Found in the top-left corner of the GCP Console.
- `<region>`: Region selected earlier (e.g., `us-central1`).
- `<cluster-name>`: The name of the cluster you created (e.g., `aktus-marketplace-cluster`).

> ✅ You are now connected to your cluster.

---

### 1.2 Enable GCS Fuse CSI Driver

```bash
gcloud container clusters update <cluster-name> \
  --update-addons GcsFuseCsiDriver=ENABLED \
  --location=<region>
```

- Replace `<cluster-name>` and `<region>` accordingly.

> 🔄 Use the refresh button on the cluster page to check status.  
> 🕒 This process can take up to **30 minutes** to complete in the background.

---

### 1.3 Update Node Pools for Workload Identity

Update the `non-gpu-pool`:

```bash
gcloud container node-pools update non-gpu-pool \
  --cluster=<cluster-name> \
  --location=<region> \
  --workload-metadata=GKE_METADATA
```

Repeat for the `gpu-pool`:

```bash
gcloud container node-pools update gpu-pool \
  --cluster=<cluster-name> \
  --location=<region> \
  --workload-metadata=GKE_METADATA
```

---

### 1.4 Create GCP Service Account

1. Navigate to **IAM & Admin > Service Accounts** in the GCP Console.
2. Click **Create Service Account**.
3. Enter a name, such as `aktus-marketplace-sa`.
4. Click **Create**, then click **Continue**.
5. In the **Permissions** section:
   - Filter for `Storage`.
   - Select **Storage Admin**.
6. Click **Done** to finish.

---

### 1.5 Create Kubernetes Namespace

In Cloud Shell, run:

```bash
kubectl create namespace <namespace>
```

- `<namespace>`: Can be the name of your choice, in our tutorial video we call it `platform-dev-demo`

---

### 1.6 Bind IAM Policy to Kubernetes Service Account

```bash
gcloud iam service-accounts add-iam-policy-binding <service-account-email> \
  --role="roles/iam.workloadIdentityUser" \
  --member="principal://iam.googleapis.com/projects/<project-number>/locations/global/workloadIdentityPools/<project-id>.svc.id.goog/subject/ns/<namespace>/sa/<your-application-name>-serviceaccount"
```

Replace the placeholders with:

- `<service-account-email>`: Navigate to **IAM & Admin > Service Accounts**, copy the email of the service account you just created.
- `<project-number>`: Click the **three-dot menu** next to your user icon on the top right, then go to **Project Settings** to find the number.
- `<project-id>`: Found in the top-left corner of the console.
- `<your-application-name>`: Can be any name, e.g., `aktus-ai-platform-marketplace`.
- `<namespace>`: The namespace you defined in the previous step.

---

### 1.7 Grant Storage Access to the Kubernetes Service Account

```bash
gcloud projects add-iam-policy-binding <project-id> \
  --member="principal://iam.googleapis.com/projects/<project-number>/locations/global/workloadIdentityPools/<project-id>.svc.id.goog/subject/ns/platform-dev-demo/sa/<your-application-name>-serviceaccount" \
  --role="roles/storage.objectUser"
```

Replace:

- `<project-id>`: From the top-left of the GCP Console (e.g., `aktus-ai-platform-public`)
- `<project-number>`: Retrieved from Project Settings
- `<your-application-name>`: As used in previous command

---

> ✅ Once complete, return to the **Aktus Deployment Page** and continue the configuration process.

---

<div align="center">

**Next Step:** [Network Configuration](network-configuration.md) →

</div>
