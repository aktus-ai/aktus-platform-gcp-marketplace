# Aktus AI Platform
> **Enterprise AI for Research, Knowledge Management, and Data Processing**

Deploy Aktus AI Platform on Google Cloud Marketplace with our comprehensive deployment guide.

---

## 🚀 Quick Start

### Installation Resources
- **[📺 Complete Video Series](docs/installation-video.md)** — Watch step-by-step installation videos
- **[📚 Documentation Guides](docs/)** — Detailed written instructions

### Step-by-Step Guides
1. **[Cluster Setup](docs/cluster-setup.md)** — GKE cluster and Workload Identity
2. **[Network Configuration](docs/network-configuration.md)** — Static IPs and firewall rules  
3. **[Storage Configuration](docs/storage-configuration.md)** — GCS buckets and permissions
4. **[Marketplace Deployment](docs/marketplace-deployment.md)** — Deploy from Google Cloud Marketplace

---

## 📋 Prerequisites

### Required Resources
- Google Cloud Project with billing enabled
- Google Cloud SDK installed
- `kubectl` installed
- Project Owner permissions
- OpenAI API key
- Hugging Face login token

### Cluster Requirements
- Minimum 4 nodes
  - `e2-standard-16` x 3
  - `a2-highgpu-1g` (NVIDIA Tesla A100 40Gi)


### Required GCP Resources
- 1 External Static IP address
- 3 GCS Buckets:
  - Document Upload Bucket
  - Document Processing Bucket
  - Extracted Data Bucket

---

## 🎯 Platform Features

| Feature | Description |
|---------|-------------|
| **Research Service** | Web interface for knowledge exploration |
| **Inference Service** | ML model inference with GPU acceleration |
| **Database Service** | Data management and storage |
| **Multimodal Ingestion** | Document and image processing |
| **Embedding Service** | Vector embeddings for semantic search |
| **Knowledge Assistant** | Interactive chat interface |
| **Vector Database** | Qdrant for semantic search |

---

## 📺 Installation Videos

**Infrastructure Setup:**
- **[Create_Cluster](https://drive.google.com/file/d/1jN72wLWiD_R-nyb-ry0W6oLpD9LY16Rv/view?usp=sharing)** `30 min` — Create standard GKE cluster and enable Workload Identity
- **[GCSFuse_Cluster](https://drive.google.com/file/d/19wrUxLJXTvxQqUjrmbE3bfO3EHhNuvZh/view?usp=sharing)** `30 min` — Enable GCS Fuse CSI Driver on cluster
- **[GCSFuse_Node](https://drive.google.com/file/d/1z2T3Al1JHzTSJB_VwrAz7C1XL636UfQw/view?usp=sharing)** `10 min` — Enable GCS Fuse on node pools
- **[Create_IP_Addresses](https://drive.google.com/file/d/1p-TYGfNnmxeVhxobTVmoXr5i7H9w-OZP/view?usp=sharing)** `5 min` — Create static IP addresses and firewall rules
- **[Create_Buckets](https://drive.google.com/file/d/194XKRYR4rNB7rdlhfhMxtLPWRdEgJKd1/view?usp=sharing)** `6 min` — Create GCS buckets and configure permissions

**Deployment & Testing:**
- **[Deploy](https://drive.google.com/file/d/1Hz256McmAUep-yTbBIa0vW2W_aRTCxUK/view?usp=sharing)** `10 min` — Google Cloud Marketplace deployment
- **[Embed](https://drive.google.com/file/d/1_rlsF6Sequa8Mcf3NKY0yoXKZWTXZ8-o/view?usp=sharing)** `Variable` — Upload and embed documents
- **[Test](https://drive.google.com/file/d/1Vg5s7XBMkC2RF_xlPcRpUUaxW-G7F8em/view?usp=sharing)** `5 min` — Test AI functionality with questions

---

## ⚡ Deployment Sequence

| Step | Video | Duration | Purpose |
|------|-------|----------|---------|
| **1** | [Create_Cluster](https://drive.google.com/file/d/1jN72wLWiD_R-nyb-ry0W6oLpD9LY16Rv/view?usp=sharing) | `30 min` | Cluster + Identity |
| **2** | [GCSFuse_Cluster](https://drive.google.com/file/d/19wrUxLJXTvxQqUjrmbE3bfO3EHhNuvZh/view?usp=sharing) | `30 min` | Cluster GCS Fuse |
| **3** | [GCSFuse_Node](https://drive.google.com/file/d/1z2T3Al1JHzTSJB_VwrAz7C1XL636UfQw/view?usp=sharing) | `10 min` | Node GCS Fuse |
| **4** | [Create_IP_Address](https://drive.google.com/file/d/1p-TYGfNnmxeVhxobTVmoXr5i7H9w-OZP/view?usp=sharing) | `5 min` | Static IPs |
| **5** | [Create_Buckets](https://drive.google.com/file/d/194XKRYR4rNB7rdlhfhMxtLPWRdEgJKd1/view?usp=sharing) | `6 min` | GCS buckets |
| **6** | [Deploy](https://drive.google.com/file/d/1Hz256McmAUep-yTbBIa0vW2W_aRTCxUK/view?usp=sharing) | `10 min` | Marketplace deploy |
| **7** | ⏱️ **Wait 5 minutes** | — | Pod initialization |
| **8** | [Embed](https://drive.google.com/file/d/1_rlsF6Sequa8Mcf3NKY0yoXKZWTXZ8-o/view?usp=sharing) | `Variable` | Document processing |
| **9** | [Test](https://drive.google.com/file/d/1Vg5s7XBMkC2RF_xlPcRpUUaxW-G7F8em/view?usp=sharing) | `5 min` | Test functionality |

> **Total Time:** ~96 minutes + document processing

---

## 🌐 Access Your Platform

After successful deployment:

- **Knowledge Assistant:** `http://<knowledge-assistant-ip>:3000`

---

## 💬 Support

- **📧 Email:** [support@aktus.ai](mailto:support@aktus.ai)
- **🐛 Issues:** [GitHub Issues](https://github.com/aktus-ai/aktus-platform-gcp-marketplace/issues)
- **📖 Documentation:** [docs/](docs/)

---

<div align="center">

**Ready to deploy your AI platform?** 🚀

*Version 1.0.16 | Last Updated: July 2025*

</div>
