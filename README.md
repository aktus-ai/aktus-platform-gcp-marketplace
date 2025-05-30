# Aktus AI Platform
**Enterprise AI for Research, Knowledge Management, and Data Processing**

Deploy Aktus AI Platform on Google Cloud Marketplace with our step-by-step guide.

---

## Quick Start

### 🎥 Installation Videos
**[📹 Complete Video Series](docs/installation-video.md)** - Download all installation videos

### 📚 Written Guides
1. **[Step 1: Cluster Setup](docs/cluster-setup.md)** - Create GKE cluster and Workload Identity
2. **[Step 2: Network Config](docs/network-configuration.md)** - Create static IPs and firewall rules  
3. **[Step 3: Storage Config](docs/storage-configuration.md)** - Create GCS buckets and permissions
4. **[Step 4: Marketplace Deploy](docs/marketplace-deployment.md)** - Deploy from Google Cloud Marketplace

---

## Prerequisites

- Google Cloud Project with billing enabled
- Google Cloud SDK installed
- `kubectl` installed  
- Project Owner permissions
- OpenAI API key
- Hugging Face login token

---

## Features

- **Research Service** - Web interface for knowledge exploration
- **Inference Service** - ML model inference with GPU acceleration
- **Database Service** - Data management and storage
- **Multimodal Data Ingestion** - Document and image processing
- **Embedding Service** - Vector embeddings for semantic search
- **Knowledge Assistant** - Interactive chat interface
- **Vector Database** - Qdrant for semantic search

---

## Deployment Sequence

Follow the videos in order:

| Order | Video | Duration | Purpose |
|-------|-------|----------|---------|
| 1 | [Create_Cluster](https://drive.google.com/file/d/1jN72wLWiD_R-nyb-ry0W6oLpD9LY16Rv/view?usp=sharing) | 30 min | Cluster + Identity |
| 2 | [GCSFuse_Cluster](https://drive.google.com/file/d/19wrUxLJXTvxQqUjrmbE3bfO3EHhNuvZh/view?usp=sharing) | 30 min | Cluster GCS Fuse |
| 3 | [GCSFuse_Node](https://drive.google.com/file/d/1z2T3Al1JHzTSJB_VwrAz7C1XL636UfQw/view?usp=sharing) | 10 min | Node GCS Fuse |
| 4 | [Create_IP_Addresses](https://drive.google.com/file/d/1p-TYGfNnmxeVhxobTVmoXr5i7H9w-OZP/view?usp=sharing) | 5 min | Static IPs |
| 5 | [Create_Buckets](https://drive.google.com/file/d/194XKRYR4rNB7rdlhfhMxtLPWRdEgJKd1/view?usp=sharing) | 6 min | GCS buckets |
| 6 | [Deploy](https://drive.google.com/file/d/1Hz256McmAUep-yTbBIa0vW2W_aRTCxUK/view?usp=sharing) | 10 min | Marketplace deploy |
| 7 | **⏱️ Wait 5 minutes** | - | Pod initialization |
| 8 | [Embed](https://drive.google.com/file/d/1_rlsF6Sequa8Mcf3NKY0yoXKZWTXZ8-o/view?usp=sharing) | Variable | Document processing |
| 9 | [Test](https://drive.google.com/file/d/1Vg5s7XBMkC2RF_xlPcRpUUaxW-G7F8em/view?usp=sharing) | 5 min | Test functionality |

**Total Time:** ~96 minutes + document processing

---

## Access Your Platform

After deployment:

- **Research Service:** `http://<research-ip>:8080`
- **Knowledge Assistant:** `http://<knowledge-assistant-ip>:3000`

---

## Support

- **Email:** [support@aktus.ai](mailto:support@aktus.ai)
- **GitHub Issues:** [Report Issues](https://github.com/aktus-ai/aktus-platform-gcp-marketplace/issues)
- **Documentation:** [docs/](docs/)

---

**🚀 Ready to deploy your AI platform!**

*Version: 1.0.3 | Last Updated: May 2025*
