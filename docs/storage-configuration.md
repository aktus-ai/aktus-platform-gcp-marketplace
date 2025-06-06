# Storage Configuration
> **Step 3:** Create Google Cloud Storage (GCS) buckets for Aktus AI Platform data storage and model artifacts

---

## 🎥 Related Videos
- **[Create_Buckets](https://drive.google.com/file/d/194XKRYR4rNB7rdlhfhMxtLPWRdEgJKd1/view?usp=sharing)** `6 min`

---

## 📋 Prerequisites

- Completed Steps 1-2
- Cloud Storage API enabled

---

## ⚡ Quick Setup

### Environment Variables
```bash
export PROJECT_ID="your-project-id"
export REGION="us-central1"
export BUCKET_SUFFIX=$(date +%Y%m%d-%H%M%S)
export DOC_UPLOAD_BUCKET="aktus-doc-upload-${PROJECT_ID}-${BUCKET_SUFFIX}"
export DOC_PROCESSING_BUCKET="aktus-doc-processing-${PROJECT_ID}-${BUCKET_SUFFIX}"
export EXTRACTED_DATA_BUCKET="aktus-extracted-data-${PROJECT_ID}-${BUCKET_SUFFIX}"
```

### Create GCS Buckets
```bash
gsutil mb -p $PROJECT_ID -c STANDARD -l $REGION gs://$DOC_UPLOAD_BUCKET
gsutil mb -p $PROJECT_ID -c STANDARD -l $REGION gs://$DOC_PROCESSING_BUCKET
gsutil mb -p $PROJECT_ID -c STANDARD -l $REGION gs://$EXTRACTED_DATA_BUCKET
```

---

## 🔐 Configure Permissions

```bash
export SERVICE_ACCOUNT_EMAIL="aktus-ai-platform-sa@$PROJECT_ID.iam.gserviceaccount.com"

gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://$DOC_UPLOAD_BUCKET
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://$DOC_PROCESSING_BUCKET
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://$EXTRACTED_DATA_BUCKET
```

---

## 📍 Display Bucket Names

```bash
echo "Document Upload Bucket: $DOC_UPLOAD_BUCKET"
echo "Document Processing Bucket: $DOC_PROCESSING_BUCKET"
echo "Extracted Data Bucket: $EXTRACTED_DATA_BUCKET"
```

---

## ✅ Verification

```bash
gsutil ls -p $PROJECT_ID | grep aktus
```

---

## ⚠️ Model Files Required

> **Important:** Upload required model weights to the models bucket before deployment.

**Contact for model files:** [support@aktus.ai](mailto:support@aktus.ai)

---

<div align="center">

**Next Step:** [Marketplace Deployment](marketplace-deployment.md) →

</div>