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

## ⚡ Quick Setup

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