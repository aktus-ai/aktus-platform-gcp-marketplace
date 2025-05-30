# Step 4: Google Cloud Marketplace Deployment

This guide covers deploying the Aktus AI Platform through Google Cloud Marketplace using the infrastructure created in Steps 1-3.

## 🎥 Video Guide

📹 **[Watch Step 4 Installation Video](../videos/step4-marketplace-deployment.md)**

---

## Prerequisites

- ✅ Completed [Step 1: Cluster Setup & Identity Configuration](cluster-setup.md)
- ✅ Completed [Step 2: Network Configuration](network-configuration.md)  
- ✅ Completed [Step 3: Storage Configuration](storage-configuration.md)
- ✅ Model weights uploaded to models bucket
- ✅ OpenAI API key
- ✅ Hugging Face login key

---

## Deployment Overview

Step 4 involves:
1. ✅ Access Google Cloud Marketplace
2. ✅ Configure deployment parameters
3. ✅ Complete the deployment form
4. ✅ Deploy the application
5. ✅ Verify deployment

---

## Access Google Cloud Marketplace

### Navigate to Aktus AI Platform

1. Open [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Navigate to **Marketplace** in the left menu
4. Search for "**Aktus AI Platform**"
5. Click on the Aktus AI Platform listing

### Start Configuration

1. Click **"Configure"** button
2. Select your project if not already selected
3. Choose the cluster created in Step 1

---

## Deployment Form Configuration

The deployment form is organized into 6 steps. Use the information from previous steps to fill out each section.

### Step 1: Basic Configuration & Identity

| Field | Value | Source |
|-------|-------|--------|
| **Application Name** | `aktus-ai-platform` | Choose any name |
| **Kubernetes Namespace** | `aktus-platform` | From Step 1 |
| **Service Account** | `aktus-ai-platform-sa` | From Step 1 |
| **GCP Service Account Email** | `aktus-ai-platform-sa@<PROJECT_ID>.iam.gserviceaccount.com` | From Step 1 |
| **Enable GCS Bucket Access** | ✅ **Checked** | Required for storage |

**Example:**
```
Application Name: aktus-ai-platform
Namespace: aktus-platform
Service Account: aktus-ai-platform-sa
GCP Service Account: aktus-ai-platform-sa@my-project-123.iam.gserviceaccount.com
Enable GCS Access: ✅
```

### Step 2: Network Configuration

| Field | Value | Source |
|-------|-------|--------|
| **Research Service Static IP** | `XX.XX.XX.XX` | From Step 2 |
| **Database Service Static IP** | `XX.XX.XX.XX` | From Step 2 |
| **Embedding Service Static IP** | `XX.XX.XX.XX` | From Step 2 |
| **Knowledge Assistant Static IP** | `XX.XX.XX.XX` | From Step 2 |

**Get your IPs from Step 2:**
```bash
# Run these commands to get your static IPs
export PROJECT_ID="your-project-id"
export REGION="us-central1"

gcloud compute addresses describe aktus-research-service-ip --region=$REGION --format="value(address)"
gcloud compute addresses describe aktus-database-service-ip --region=$REGION --format="value(address)"
gcloud compute addresses describe aktus-embedding-service-ip --region=$REGION --format="value(address)"  
gcloud compute addresses describe aktus-knowledge-assistant-ip --region=$REGION --format="value(address)"
```

### Step 3: Storage Configuration

| Field | Value | Source |
|-------|-------|--------|
| **Models Storage Bucket** | `aktus-models-<project>-<timestamp>` | From Step 3 |
| **Document Upload Bucket** | `aktus-doc-upload-<project>-<timestamp>` | From Step 3 |
| **Document Processing Bucket** | `aktus-doc-processing-<project>-<timestamp>` | From Step 3 |
| **Extracted Data Bucket** | `aktus-extracted-data-<project>-<timestamp>` | From Step 3 |

**Get your bucket names from Step 3:**
```bash
# List your buckets to copy the exact names
gsutil ls -p $PROJECT_ID | grep aktus
```

### Step 4: Service Selection

Enable all services for complete functionality:

| Service | Enable | Purpose |
|---------|--------|---------|
| **Database Service** | ✅ | Data management and storage |
| **Knowledge Assistant** | ✅ | Interactive chat interface |
| **Inference Service** | ✅ | ML model inference (requires GPU) |
| **Embedding Service** | ✅ | Vector embeddings (requires OpenAI) |
| **Research Service** | ✅ | Research analytics |
| **Multimodal Data Ingestion** | ✅ | Document processing |
| **Qdrant Vector Database** | ✅ | Vector storage |

**Recommended Selection:** Enable all services for full functionality.

### Step 5: API Keys & Secrets

| Field | Value | Requirements |
|-------|-------|-------------|
| **OpenAI API Key** | `sk-...` | Required for embedding service |
| **Hugging Face Login Key** | `hf_...` | Required for model downloads |

**Getting API Keys:**

**OpenAI API Key:**
1. Visit [OpenAI Platform](https://platform.openai.com/)
2. Go to **API Keys** section
3. Create a new API key
4. Copy the key (starts with `sk-`)

**Hugging Face Login Key:**
1. Visit [Hugging Face](https://huggingface.co/)
2. Go to **Settings** → **Access Tokens**
3. Create a new token with **Read** permissions
4. Copy the token (starts with `hf_`)

---

## Deploy the Application

### Final Review

Before deployment, verify all information:

1. ✅ All static IP addresses are correct
2. ✅ All bucket names are exact matches
3. ✅ Service account email is correct
4. ✅ API keys are valid
5. ✅ All required services are enabled

### Click Deploy

1. Review the estimated costs
2. Accept the terms of service
3. Click **"Deploy"** button

### Monitor Deployment Progress

The deployment typically takes **15-20 minutes**. You can monitor progress:

1. **In Google Cloud Console:**
   - Go to **Kubernetes Engine** → **Applications**
   - Find your Aktus AI Platform deployment
   - Click to view status and details

2. **Using kubectl:**
   ```bash
   # Monitor pods
   kubectl get pods -n aktus-platform -w
   
   # Check services
   kubectl get services -n aktus-platform
   
   # View deployment status
   kubectl get deployments -n aktus-platform
   ```

---

## Verify Deployment

### Check All Pods Are Running

```bash
kubectl get pods -n aktus-platform
```

**Expected output:** All pods should show `Running` status.

### Check Services Have External IPs

```bash
kubectl get services -n aktus-platform
```

**Expected output:** Services should show the static IPs you configured.

### Test Service Access

```bash
# Get service IPs (should match your static IPs)
export RESEARCH_IP=$(kubectl get service aktus-research-service -n aktus-platform -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export KNOWLEDGE_ASSISTANT_IP=$(kubectl get service aktus-knowledge-assistant-service -n aktus-platform -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Research Service: http://$RESEARCH_IP:8080"
echo "Knowledge Assistant: http://$KNOWLEDGE_ASSISTANT_IP:3000"
```

### Access the Applications

1. **Research Service:** `http://<research-ip>:8080`
2. **Knowledge Assistant:** `http://<knowledge-assistant-ip>:3000`

---

## Post-Deployment Configuration

### Upload Documents

1. Access the Knowledge Assistant interface
2. Use the document upload feature  
3. Documents will be processed and stored in your GCS buckets

### Configure Users (Optional)

```bash
# Access the database to configure users
kubectl exec -it deployment/aktus-database-service -n aktus-platform -- psql -U postgres
```

### Monitor Resource Usage

```bash
# Check resource usage
kubectl top pods -n aktus-platform
kubectl top nodes
```

---

## Troubleshooting

### Common Deployment Issues

**Issue:** Pods stuck in `Pending` state  
**Solution:**
1. Check if GPU nodes are available: `kubectl get nodes -l cloud.google.com/gke-accelerator=nvidia-tesla-a100`
2. Verify node resources: `kubectl describe nodes`
3. Check PVC status: `kubectl get pvc -n aktus-platform`

**Issue:** Services don't get external IPs  
**Solution:**
1. Verify static IPs exist: `gcloud compute addresses list`
2. Check if IPs are in the correct region
3. Verify firewall rules: `gcloud compute firewall-rules list`

**Issue:** Model inference service fails  
**Solution:**
1. Verify model files are uploaded to the models bucket
2. Check service account has access to GCS buckets
3. Verify Workload Identity is properly configured

**Issue:** Authentication errors with GCS  
**Solution:**
1. Verify service account exists: `gcloud iam service-accounts list`
2. Check Workload Identity binding
3. Verify bucket permissions: `gsutil iam get gs://<bucket-name>`

### Get Logs for Debugging

```bash
# Get logs for specific service
kubectl logs deployment/aktus-inference-service -n aktus-platform

# Get logs for all pods
kubectl logs -l app.kubernetes.io/name=aktus-platform -n aktus-platform

# Describe pod for detailed status
kubectl describe pod <pod-name> -n aktus-platform
```

---

## Scaling and Optimization

### Scale GPU Inference Service

```bash
# Scale inference service for more capacity
kubectl scale deployment aktus-inference-service -n aktus-platform --replicas=2
```

### Monitor Costs

1. Go to **Billing** in Google Cloud Console
2. View **Cost Breakdown** by service
3. Set up **Budget Alerts** for cost monitoring

### Performance Optimization

```bash
# Enable horizontal pod autoscaling
kubectl autoscale deployment aktus-embedding-service -n aktus-platform --cpu-percent=70 --min=1 --max=5
```

---

## Next Steps

After successful deployment:

1. 📚 **Upload your documents** to start using the platform
2. 🔧 **Configure users and permissions** as needed
3. 📊 **Monitor performance and costs**
4. 🛡️ **Set up backup procedures** for critical data
5. 📈 **Scale services** based on usage patterns

---

## Support and Resources

### Getting Help

- **Email Support:** [support@aktus.ai](mailto:support@aktus.ai)
- **Documentation:** [GitHub Repository](https://github.com/aktus-ai/aktus-platform-gcp-marketplace)
- **Community:** [GitHub Issues](https://github.com/aktus-ai/aktus-platform-gcp-marketplace/issues)

### Additional Resources

- [Kubernetes Engine Documentation](https://cloud.google.com/kubernetes-engine/docs)
- [Google Cloud Marketplace](https://cloud.google.com/marketplace/docs)
- [Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)
- [Cloud Storage Integration](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/cloud-storage-fuse-csi-driver)

---

**🎉 Congratulations!** Your Aktus AI Platform is now deployed and ready to use. 