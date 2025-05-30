# 🎥 Aktus AI Platform Installation Videos

Complete video series for deploying Aktus AI Platform on Google Cloud Marketplace.

---

## 📹 Video Downloads

### Infrastructure Setup Videos

#### [🔧 Create_Cluster (30 min)](videos/create-cluster.mp4)
Create standard GKE cluster and enable Workload Identity

#### [🌐 Network Configuration (5 min)](videos/network-config.mp4)
Create static IP addresses and firewall rules

#### [💾 Storage Configuration (6 min)](videos/storage-config.mp4)
Create GCS buckets and configure permissions

#### [📁 GCSFuse-cluster (30 min)](videos/gcsfuse-cluster.mp4)
Enable GCS Fuse CSI Driver on cluster

#### [📁 GCSFuse-node (10 min)](videos/gcsfuse-node.mp4)
Enable GCS Fuse on node pools

### Deployment & Testing Videos

#### [🚀 Deploy (10 min)](videos/deploy.mp4)
Google Cloud Marketplace deployment

#### [📄 Embed (Variable duration)](videos/embed.mp4)
Upload and embed documents (*processing time varies by document size*)

#### [❓ Test (5 min)](videos/test.mp4)
Test AI functionality with questions

---

## 🎯 Deployment Sequence

| Order | Video | Duration | Purpose |
|-------|-------|----------|---------|
| 1 | Create_Cluster | 30 min | Cluster + Identity |
| 2 | Network Configuration | 5 min | Static IPs |
| 3 | Storage Configuration | 6 min | GCS buckets |
| 4 | GCSFuse-cluster | 30 min | Cluster GCS Fuse |
| 5 | GCSFuse-node | 10 min | Node GCS Fuse |
| 6 | Deploy | 10 min | Marketplace deploy |
| 7 | **⏱️ Wait 5 minutes** | - | Pod initialization |
| 8 | Embed | Variable | Document processing |
| 9 | Test | 5 min | Functionality test |

**Total Time:** ~96 minutes + document processing

---

## 📋 Prerequisites

- ✅ Google Cloud Project with billing enabled
- ✅ Google Cloud SDK installed
- ✅ `kubectl` installed
- ✅ Project Owner permissions
- ✅ OpenAI API key
- ✅ Hugging Face login token
- ✅ Sample documents for testing

---

## ⚠️ Important Notes

- **GCS Fuse:** Both cluster and node videos are required
- **Wait Time:** Allow 5 minutes after deployment before testing
- **Document Processing:** Time varies based on document size and type

---

## 📖 Written Guides

- [Cluster Setup Guide](cluster-setup.md)
- [Network Configuration Guide](network-configuration.md)
- [Storage Configuration Guide](storage-configuration.md)
- [Marketplace Deployment Guide](marketplace-deployment.md)

---

## 💬 Support

- **Email:** [support@aktus.ai](mailto:support@aktus.ai)
- **GitHub Issues:** [Report Issues](https://github.com/aktus-ai/aktus-platform-gcp-marketplace/issues)

---

**🎥 Follow the videos in sequence for complete deployment!**

*Last Updated: December 2024*