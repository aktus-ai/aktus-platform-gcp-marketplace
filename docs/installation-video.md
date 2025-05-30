# 🎥 Aktus AI Platform Installation Videos

Complete video series for deploying Aktus AI Platform on Google Cloud Marketplace.

---

## 📹 Video Downloads

### Infrastructure Setup Videos

#### [🔧 Create_Cluster (30 min)](videos/Create_Cluster.mov)
Create standard GKE cluster and enable Workload Identity

#### [🌐 Network Configuration (5 min)](videos/Create_IP_Addresses.mov)
Create static IP addresses and firewall rules

#### [💾 Storage Configuration (6 min)](videos/Create_Buckets.mov)
Create GCS buckets and configure permissions

#### [📁 GCSFuse-cluster (30 min)](videos/GCSFuse_Cluster.mov)
Enable GCS Fuse CSI Driver on cluster

#### [📁 GCSFuse-node (10 min)](videos/GCSFuse_Node.mov)
Enable GCS Fuse on node pools

### Deployment & Testing Videos

#### [🚀 Deploy (10 min)](videos/Deploy.mov)
Google Cloud Marketplace deployment

#### [📄 Embed (Variable duration)](videos/Embed.mov)
Upload and embed documents (*processing time varies by document size*)

#### [❓ Test (5 min)](videos/Test.mov)
Test AI functionality with questions

---

## 🎯 Deployment Sequence

| Order | Video | Duration | Purpose |
|-------|-------|----------|---------|
| 1 | Create_Cluster | 30 min | Cluster + Identity |
| 2 | Create_IP_Addresses | 5 min | Static IPs |
| 3 | Create_Buckets | 6 min | GCS buckets |
| 4 | GCSFuse_Cluster | 30 min | Cluster GCS Fuse |
| 5 | GCSFuse_Node | 10 min | Node GCS Fuse |
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