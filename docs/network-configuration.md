# Network Configuration
> **Step 2:** Create external static IP addresses for all Aktus AI Platform services

---

## 🎥 Related Videos
- **[Create_IP_Address](https://drive.google.com/file/d/1p-TYGfNnmxeVhxobTVmoXr5i7H9w-OZP/view?usp=sharing)** `5 min`

---

## 📋 Prerequisites

- Completed Step 1 (Cluster Setup)
- Google Cloud SDK configured

---

## 🌐 Step 2: Creating a Static IP Address in the GCP Interface

A static external IP is required for the deployment process.

---

### 1. Open the IP Addresses Console page

- In the Google Cloud Console, use the search bar at the top to search for **“IP addresses”**.

---

### 2. Reserve a Static IP

- Click **“Reserve External Static IP Address”**.
- Give the IP address a name.  
  > 📝 **Tip**: Include the word `research` in the name to help identify its purpose later.

- Click the **“Reserve”** button at the bottom of the form.

---

### 3. Complete Configuration

- Return to the **Aktus deployment page** and paste the reserved IP address into the appropriate field labeled "Research Service Static IP".

---

## ⚡ Quick Setup via Cloud Shell

### Environment Variables
```bash
export PROJECT_ID="your-project-id"
export REGION="us-central1"
```

### Create Static IP Address
```bash
# Research Service Static IP
gcloud compute addresses create aktus-research-service-ip \
  --region=$REGION \
  --project=$PROJECT_ID
```

---

## 📍 Get IP Address

```bash
export RESEARCH_IP=$(gcloud compute addresses describe aktus-research-service-ip --region=$REGION --format="value(address)")

echo "Research Service IP: $RESEARCH_IP"
```

---

## ✅ Verification

```bash
gcloud compute addresses list --filter="region:$REGION" --project=$PROJECT_ID
```

---

<div align="center">

**Next Step:** [Storage Configuration](storage-configuration.md) →

</div>
