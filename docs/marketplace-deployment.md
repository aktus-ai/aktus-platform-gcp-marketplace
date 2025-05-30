# Step 4: Marketplace Deployment

Deploy Aktus AI Platform through Google Cloud Marketplace.

## Prerequisites

- ✅ Completed Steps 1-3
- ✅ OpenAI API key
- ✅ Hugging Face login token

## Deployment Steps

### 1. Access Google Cloud Marketplace
1. Open [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **Marketplace**
3. Search for "**Aktus AI Platform**"
4. Click **Configure**

### 2. Fill Deployment Form

#### Step 1: Basic Configuration
- **Application Name:** `aktus-ai-platform`
- **Namespace:** `aktus-platform`
- **Service Account:** `aktus-ai-platform-sa`
- **GCP Service Account:** `aktus-ai-platform-sa@<PROJECT_ID>.iam.gserviceaccount.com`
- **Enable GCS Access:** ✅ Checked

#### Step 2: Network Configuration
Enter your static IP addresses from Step 2:
- **Research Service IP:** `XX.XX.XX.XX`
- **Database Service IP:** `XX.XX.XX.XX`
- **Embedding Service IP:** `XX.XX.XX.XX`
- **Knowledge Assistant IP:** `XX.XX.XX.XX`

#### Step 3: Storage Configuration
Enter your bucket names from Step 3:
- **Models Bucket:** `aktus-models-<project>-<timestamp>`
- **Document Upload Bucket:** `aktus-doc-upload-<project>-<timestamp>`
- **Processing Bucket:** `aktus-doc-processing-<project>-<timestamp>`
- **Extracted Data Bucket:** `aktus-extracted-data-<project>-<timestamp>`

#### Step 4: Service Selection
Enable all services:
- ✅ Database Service
- ✅ Knowledge Assistant
- ✅ Inference Service
- ✅ Embedding Service
- ✅ Research Service
- ✅ Multimodal Data Ingestion
- ✅ Qdrant Vector Database

#### Step 5: API Keys
- **OpenAI API Key:** `sk-...`
- **Hugging Face Login Key:** `hf_...`

### 3. Deploy
1. Review configuration
2. Click **Deploy**
3. Wait 15-20 minutes for completion

## Verification

### Check Deployment Status
```bash
kubectl get pods -n aktus-platform
kubectl get services -n aktus-platform
```

### Access Services
- **Research Service:** `http://<research-ip>:8080`
- **Knowledge Assistant:** `http://<knowledge-assistant-ip>:3000`

## Post-Deployment

### Wait Before Testing
⏱️ **Wait 5 minutes** after deployment for pods to fully initialize.

### Monitor Progress
```bash
kubectl get pods -n aktus-platform -w
```

## Getting API Keys

### OpenAI API Key
1. Visit [OpenAI Platform](https://platform.openai.com/)
2. Go to **API Keys**
3. Create new key (starts with `sk-`)

### Hugging Face Token
1. Visit [Hugging Face](https://huggingface.co/)
2. Go to **Settings** → **Access Tokens**
3. Create Read token (starts with `hf_`)

## Support

- **Email:** [support@aktus.ai](mailto:support@aktus.ai)
- **GitHub Issues:** [Report Issues](https://github.com/aktus-ai/aktus-platform-gcp-marketplace/issues)

---

**🎉 Deployment Complete!** Your Aktus AI Platform is now ready to use. 