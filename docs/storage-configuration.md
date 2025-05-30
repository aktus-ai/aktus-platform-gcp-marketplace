# Step 3: Storage Configuration

This guide covers creating Google Cloud Storage (GCS) buckets required for Aktus AI Platform data storage and model artifacts.

## 🎥 Video Guide

📹 **[Watch Step 3 Installation Video](../videos/step3-storage-config.md)**

---

## Prerequisites

- Completed [Step 1: Cluster Setup & Identity Configuration](cluster-setup.md)
- Completed [Step 2: Network Configuration](network-configuration.md)
- Google Cloud SDK configured
- Cloud Storage API enabled

---

## Storage Configuration Overview

Step 3 creates **4 GCS buckets** for:
1. ✅ **Models Bucket** - ML model weights and artifacts (MiniCPM, YOLO, etc.)
2. ✅ **Document Upload Bucket** - User document uploads
3. ✅ **Processing Bucket** - Intermediate processing files
4. ✅ **Extracted Data Bucket** - Processed document data and results

---

## Create GCS Buckets

### Set Environment Variables

Use the same variables from previous steps:

```bash
# If you're in a new terminal session, set these again
export PROJECT_ID="your-project-id"
export REGION="us-central1"  # Must match your cluster region

# Generate unique bucket names (buckets must be globally unique)
export BUCKET_SUFFIX=$(date +%Y%m%d-%H%M%S)
export MODELS_BUCKET="aktus-models-${PROJECT_ID}-${BUCKET_SUFFIX}"
export DOC_UPLOAD_BUCKET="aktus-doc-upload-${PROJECT_ID}-${BUCKET_SUFFIX}"
export DOC_PROCESSING_BUCKET="aktus-doc-processing-${PROJECT_ID}-${BUCKET_SUFFIX}"
export EXTRACTED_DATA_BUCKET="aktus-extracted-data-${PROJECT_ID}-${BUCKET_SUFFIX}"
```

### Create All Required Buckets

```bash
# 1. Models Storage Bucket (for ML models and artifacts)
gsutil mb -p $PROJECT_ID -c STANDARD -l $REGION gs://$MODELS_BUCKET

# 2. Document Upload Bucket (for user uploads)
gsutil mb -p $PROJECT_ID -c STANDARD -l $REGION gs://$DOC_UPLOAD_BUCKET

# 3. Document Processing Bucket (for intermediate processing)
gsutil mb -p $PROJECT_ID -c STANDARD -l $REGION gs://$DOC_PROCESSING_BUCKET

# 4. Extracted Data Bucket (for processed results)
gsutil mb -p $PROJECT_ID -c STANDARD -l $REGION gs://$EXTRACTED_DATA_BUCKET
```

---

## Configure Bucket Permissions

### Grant Service Account Access

```bash
# Set service account email from Step 1
export SERVICE_ACCOUNT_EMAIL="aktus-ai-platform-sa@$PROJECT_ID.iam.gserviceaccount.com"

# Grant Storage Object Admin role to service account for all buckets
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://$MODELS_BUCKET
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://$DOC_UPLOAD_BUCKET
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://$DOC_PROCESSING_BUCKET
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://$EXTRACTED_DATA_BUCKET
```

### Configure Bucket Lifecycle (Optional)

Set up lifecycle policies for cost optimization:

```bash
# Create lifecycle configuration for processing bucket (temporary files)
cat > processing-lifecycle.json << EOF
{
  "lifecycle": {
    "rule": [
      {
        "action": {"type": "Delete"},
        "condition": {"age": 30}
      }
    ]
  }
}
EOF

gsutil lifecycle set processing-lifecycle.json gs://$DOC_PROCESSING_BUCKET

# Create lifecycle configuration for extracted data (longer retention)
cat > extracted-data-lifecycle.json << EOF
{
  "lifecycle": {
    "rule": [
      {
        "action": {"type": "SetStorageClass", "storageClass": "NEARLINE"},
        "condition": {"age": 90}
      },
      {
        "action": {"type": "SetStorageClass", "storageClass": "COLDLINE"},
        "condition": {"age": 365}
      }
    ]
  }
}
EOF

gsutil lifecycle set extracted-data-lifecycle.json gs://$EXTRACTED_DATA_BUCKET
```

---

## Verify Bucket Creation

### List All Created Buckets

```bash
gsutil ls -p $PROJECT_ID | grep aktus
```

### Check Bucket Details

```bash
# Verify bucket configuration
gsutil ls -L -b gs://$MODELS_BUCKET
gsutil ls -L -b gs://$DOC_UPLOAD_BUCKET
gsutil ls -L -b gs://$DOC_PROCESSING_BUCKET
gsutil ls -L -b gs://$EXTRACTED_DATA_BUCKET
```

### Test Bucket Access

```bash
# Test write access to each bucket
echo "Test file created $(date)" > test-file.txt

gsutil cp test-file.txt gs://$MODELS_BUCKET/
gsutil cp test-file.txt gs://$DOC_UPLOAD_BUCKET/
gsutil cp test-file.txt gs://$DOC_PROCESSING_BUCKET/
gsutil cp test-file.txt gs://$EXTRACTED_DATA_BUCKET/

# Verify files were uploaded
gsutil ls gs://$MODELS_BUCKET/
gsutil ls gs://$DOC_UPLOAD_BUCKET/
gsutil ls gs://$DOC_PROCESSING_BUCKET/
gsutil ls gs://$EXTRACTED_DATA_BUCKET/

# Clean up test files
gsutil rm gs://$MODELS_BUCKET/test-file.txt
gsutil rm gs://$DOC_UPLOAD_BUCKET/test-file.txt
gsutil rm gs://$DOC_PROCESSING_BUCKET/test-file.txt
gsutil rm gs://$EXTRACTED_DATA_BUCKET/test-file.txt
rm test-file.txt
```

---

## Prepare Model Files

### ⚠️ Important: Model Weights Required

Before deploying the Aktus AI Platform, you must upload the required model weights to the models bucket.

### Required Model Files

The platform requires these model components:

1. **MiniCPM Model** (`multimodal-large-language-model/`)
   - Model weights (`pytorch_model.bin` or safetensors)
   - Configuration files (`config.json`)
   - Tokenizer files (`tokenizer.json`, `vocab.txt`)

2. **YOLO Model** (`object-detection-model/`)
   - YOLO weights file (`yolo.pt`)
   - Model configuration

3. **Processor Files** (`processor/`)
   - Image processor configuration
   - Text processor configuration

### Upload Model Files (Example)

```bash
# Example: Upload model files to the models bucket
# Replace with your actual model file paths

# Create model directory structure
gsutil -m cp -r /path/to/your/models/* gs://$MODELS_BUCKET/

# Verify model files are uploaded
gsutil ls -r gs://$MODELS_BUCKET/
```

### Contact Support for Model Files

If you need access to the required model weights:

**📧 Email:** [support@aktus.ai](mailto:support@aktus.ai)  
**Subject:** Model Weights Access Request  
**Include:** Your project ID and intended use case

---

## Save Bucket Names for Deployment

### Display Bucket Names

```bash
echo "=== GCS Bucket Names Created ==="
echo "Models Bucket: $MODELS_BUCKET"
echo "Document Upload Bucket: $DOC_UPLOAD_BUCKET"
echo "Document Processing Bucket: $DOC_PROCESSING_BUCKET"
echo "Extracted Data Bucket: $EXTRACTED_DATA_BUCKET"
echo "================================"
```

### Save to File

```bash
cat > gcs-buckets.txt << EOF
# Aktus AI Platform GCS Buckets
# Project: $PROJECT_ID
# Region: $REGION
# Created: $(date)

Models Bucket: $MODELS_BUCKET
Document Upload Bucket: $DOC_UPLOAD_BUCKET
Document Processing Bucket: $DOC_PROCESSING_BUCKET
Extracted Data Bucket: $EXTRACTED_DATA_BUCKET
EOF

echo "Bucket names saved to gcs-buckets.txt"
```

---

## Security Best Practices

### Bucket Security Configuration

```bash
# Enable uniform bucket-level access (recommended)
gsutil uniformbucketlevelaccess set on gs://$MODELS_BUCKET
gsutil uniformbucketlevelaccess set on gs://$DOC_UPLOAD_BUCKET
gsutil uniformbucketlevelaccess set on gs://$DOC_PROCESSING_BUCKET
gsutil uniformbucketlevelaccess set on gs://$EXTRACTED_DATA_BUCKET

# Set public access prevention
gsutil pap set enforced gs://$MODELS_BUCKET
gsutil pap set enforced gs://$DOC_UPLOAD_BUCKET
gsutil pap set enforced gs://$DOC_PROCESSING_BUCKET
gsutil pap set enforced gs://$EXTRACTED_DATA_BUCKET
```

### Encryption Configuration

```bash
# Enable default encryption (using Google-managed keys)
gsutil kms encryption -d gs://$MODELS_BUCKET
gsutil kms encryption -d gs://$DOC_UPLOAD_BUCKET
gsutil kms encryption -d gs://$DOC_PROCESSING_BUCKET
gsutil kms encryption -d gs://$EXTRACTED_DATA_BUCKET
```

---

## Monitoring and Logging

### Enable Access Logging

```bash
# Create a logging bucket (optional)
export LOGGING_BUCKET="aktus-access-logs-${PROJECT_ID}-${BUCKET_SUFFIX}"
gsutil mb -p $PROJECT_ID -c STANDARD -l $REGION gs://$LOGGING_BUCKET

# Enable access logging for main buckets
gsutil logging set on -b gs://$LOGGING_BUCKET -o AccessLog gs://$MODELS_BUCKET
gsutil logging set on -b gs://$LOGGING_BUCKET -o AccessLog gs://$DOC_UPLOAD_BUCKET
gsutil logging set on -b gs://$LOGGING_BUCKET -o AccessLog gs://$DOC_PROCESSING_BUCKET
gsutil logging set on -b gs://$LOGGING_BUCKET -o AccessLog gs://$EXTRACTED_DATA_BUCKET
```

---

## Troubleshooting

### Common Issues

**Issue:** "Bucket name already exists"  
**Solution:** GCS bucket names must be globally unique. Use a different suffix or name:
```bash
export BUCKET_SUFFIX=$(date +%Y%m%d-%H%M%S)-$(whoami)
```

**Issue:** "Permission denied"  
**Solution:** Ensure you have Storage Admin role:
```bash
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="user:your-email@domain.com" \
  --role="roles/storage.admin"
```

**Issue:** "Cloud Storage API not enabled"  
**Solution:** Enable the API:
```bash
gcloud services enable storage-api.googleapis.com --project=$PROJECT_ID
```

**Issue:** Model files not accessible from pods  
**Solution:** Verify service account permissions and Workload Identity binding from Step 1.

---

## Cost Optimization Tips

1. **Use appropriate storage classes**:
   - `STANDARD` for frequently accessed data
   - `NEARLINE` for data accessed < once/month
   - `COLDLINE` for data accessed < once/quarter

2. **Set lifecycle policies** to automatically transition or delete old data

3. **Monitor usage** with Cloud Monitoring to optimize costs

4. **Use compression** for large files to reduce storage costs

---

## Environment Variables for Next Steps

Save these for Step 4 (Marketplace Deployment):

```bash
echo "=== Bucket Names for Marketplace Deployment ==="
echo "Models Bucket: $MODELS_BUCKET"
echo "Doc Upload Bucket: $DOC_UPLOAD_BUCKET"  
echo "Doc Processing Bucket: $DOC_PROCESSING_BUCKET"
echo "Extracted Data Bucket: $EXTRACTED_DATA_BUCKET"
```

---

## Next Steps

After completing Step 3, proceed to:

📍 **[Step 4: Google Cloud Marketplace Deployment](marketplace-deployment.md)** - Deploy the platform

---

## Additional Resources

- [Cloud Storage Documentation](https://cloud.google.com/storage/docs)
- [Bucket Naming Guidelines](https://cloud.google.com/storage/docs/naming-buckets)
- [Storage Classes](https://cloud.google.com/storage/docs/storage-classes)
- [Lifecycle Management](https://cloud.google.com/storage/docs/lifecycle)
- [IAM for Cloud Storage](https://cloud.google.com/storage/docs/access-control/iam)