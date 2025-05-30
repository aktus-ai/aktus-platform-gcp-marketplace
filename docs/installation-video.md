# 🎥 Aktus AI Platform Installation Videos

Complete video series for deploying Aktus AI Platform on Google Cloud Marketplace.

---

## 📹 Video Downloads

### Infrastructure Setup Videos

#### [🔧 Create_Cluster (30 min)](https://drive.google.com/file/d/1jN72wLWiD_R-nyb-ry0W6oLpD9LY16Rv/view?usp=sharing)
Create standard GKE cluster and enable Workload Identity

#### [📁 GCSFuse-cluster (30 min)](https://drive.google.com/file/d/19wrUxLJXTvxQqUjrmbE3bfO3EHhNuvZh/view?usp=sharing)
Enable GCS Fuse CSI Driver on cluster

#### [📁 GCSFuse-node (10 min)](https://drive.google.com/file/d/1z2T3Al1JHzTSJB_VwrAz7C1XL636UfQw/view?usp=sharing)
Enable GCS Fuse on node pools

#### [🌐 Network Configuration (5 min)](https://drive.google.com/file/d/1p-TYGfNnmxeVhxobTVmoXr5i7H9w-OZP/view?usp=sharing)
Create static IP addresses and firewall rules

#### [💾 Storage Configuration (6 min)](https://drive.google.com/file/d/194XKRYR4rNB7rdlhfhMxtLPWRdEgJKd1/view?usp=sharing)
Create GCS buckets and configure permissions

### Deployment & Testing Videos

#### [🚀 Deploy (10 min)](https://drive.google.com/file/d/1Hz256McmAUep-yTbBIa0vW2W_aRTCxUK/view?usp=sharing)
Google Cloud Marketplace deployment

#### [📄 Embed (Variable duration)](https://drive.google.com/file/d/1_rlsF6Sequa8Mcf3NKY0yoXKZWTXZ8-o/view?usp=sharing)
Upload and embed documents (*processing time varies by document size*)

#### [❓ Test (5 min)](https://drive.google.com/file/d/1Vg5s7XBMkC2RF_xlPcRpUUaxW-G7F8em/view?usp=sharing)
Test AI functionality with questions

---

## 🎯 Deployment Sequence

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
| 9 | [Test](https://drive.google.com/file/d/1Vg5s7XBMkC2RF_xlPcRpUUaxW-G7F8em/view?usp=sharing) | 5 min | Functionality test |

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

*Last Updated: May 2025*