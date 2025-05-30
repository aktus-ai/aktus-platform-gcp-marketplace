# Marketplace Deployment

> **Step 4:** Deploy Aktus AI Platform through Google Cloud Marketplace

---

## 🎥 Related Videos

- **[Deploy](https://drive.google.com/file/d/1Hz256McmAUep-yTbBIa0vW2W_aRTCxUK/view?usp=sharing)** `10 min`

---

## 📋 Prerequisites

- ✅ Completed Steps 1-3
- ✅ OpenAI API key
- ✅ Hugging Face login token

---

## 🚀 Deployment Process

### 1. Access Google Cloud Marketplace

1. Open [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **Marketplace**
3. Search for "**Aktus Platform**"
4. Click **Configure**

---

## ⚙️ Configuration Steps

### Basic Configuration

| Field                         | Value                                                      |
| ----------------------------- | ---------------------------------------------------------- |
| **Application Name**    | `aktus-ai-platform-marketplace`                          |
| **Namespace**           | `platform`                                               |
| **Service Account**     | `aktus-platform-sa`                                      |
| **GCP Service Account** | `aktus-platform-sa@<PROJECT_ID>.iam.gserviceaccount.com` |
| **Enable GCS Access**   | ✅ Checked                                                 |

### Network Configuration

Enter your static IP addresses from Step 2:

- **Research Service IP:** `XX.XX.XX.XX`
- **Database Service IP:** `XX.XX.XX.XX`
- **Embedding Service IP:** `XX.XX.XX.XX`
- **Knowledge Assistant IP:** `XX.XX.XX.XX`

### Storage Configuration

Enter your bucket names from Step 3:

- **Models Bucket:** `bucket-models`
- **Document Upload Bucket:** `bucket-document-upload`
- **Processing Bucket:** `bucket-document-processing`
- **Extracted Data Bucket:** `bucket-extracted-data`

### Service Selection

Enable all services:

- ✅ Database Service
- ✅ Knowledge Assistant
- ✅ Inference Service
- ✅ Embedding Service
- ✅ Research Service
- ✅ Multimodal Data Ingestion
- ✅ Qdrant Vector Database

### API Keys

- **OpenAI API Key:** `sk-...`
- **Hugging Face Login Key:** `hf_...`

---

## 🎯 Deploy & Verify

### Deploy

1. Review configuration
2. Click **Deploy**
3. Wait 15-20 minutes for completion

### Check Deployment Status

```bash
kubectl get pods -n aktus-platform
kubectl get services -n aktus-platform
```

---

## 🌐 Access Services

- **Research Service:** `http://<research-ip>:8080`
- **Knowledge Assistant:** `http://<knowledge-assistant-ip>:3000`

---

## ⏱️ Post-Deployment

### Wait Before Testing

> **Wait 5 minutes** after deployment for pods to fully initialize.

### Monitor Progress

```bash
kubectl get pods -n aktus-platform -w
```

---

## 🔑 Getting API Keys

### OpenAI API Key

1. Visit [OpenAI Platform](https://platform.openai.com/)
2. Go to **API Keys**
3. Create new key (starts with `sk-`)

### Hugging Face Token

1. Visit [Hugging Face](https://huggingface.co/)
2. Go to **Settings** → **Access Tokens**
3. Create Read token (starts with `hf_`)

---

<div align="center">

**🎉 Deployment Complete!**

Your Aktus AI Platform is now ready to use.

**📧 Support:** [support@aktus.ai](mailto:support@aktus.ai)
**🐛 Issues:** [GitHub Issues](https://github.com/aktus-ai/aktus-platform-gcp-marketplace/issues)

</div>
