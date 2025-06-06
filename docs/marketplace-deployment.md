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
| **Application Name**    | The application name from Step 1 during application installtions, e.g. `aktus-ai-platform-marketplace`.                          |
| **Namespace**           | The `namespace` from Step 1 of app installtions (`NAMESPACE`), e.g. `platform`.                                               |
| **Service Account**     | The name of the service account created during app installation (`SERVICE-ACCOUNT-NAME`), e.g.`aktus-platform-sa`.                                     |
| **GCP Service Account** | `<SERVICE-ACCOUNT-NAME>@<PROJECT_ID>.iam.gserviceaccount.com` |
| **Enable GCS Access**   | ✅ Checked                                                 |

### Network Configuration

Enter your static IP address from Step 2:

- **Research Service IP:** `XX.XX.XX.XX`

### Storage Configuration

Enter your bucket names from Step 3:

**NOTE**: GCS bucket name MUST be globally unique.

- **Document Upload Bucket:** `bucket-document-upload`
- **Processing Bucket:** `bucket-document-processing`
- **Extracted Data Bucket:** `bucket-extracted-data`

### Service Selection

Enable Production mode:

- ✅ Enable Production Mode

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
kubectl get pods -n <NAMESPACE>
kubectl get services -n <NAMESPACE>
```

---

## 🌐 Access Services

To access the frontend service, i.e. *Aktus Knowledge Assistant*, follow the steps below:

1. Locate your GKE cluster on Kubernetes Engine homepage of your GCP account.
    
2. Under the **Applications** section, find your application and click on it.
   
3. Next, find the **aktus-knowledge-assistant** `service` and open it. 
   
4. You will find the endpoint to this application listed as **External endpoints**.
   
5. Sign up on the landing page and start using the platform. 
   


---

## ⏱️ Post-Deployment

### Wait Before Testing

> **Wait 5 minutes** after deployment for pods to fully initialize.

### Monitor Progress

```bash
kubectl get pods -n <NAMESPACE> -w
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
