# 📺 Aktus AI Platform Installation Videos
> Complete video series for deploying Aktus AI Platform on Google Cloud Marketplace

---

## 🎬 Infrastructure Setup

| Video | Duration | Description |
|-------|----------|-------------|
| **[Create_Cluster](https://drive.google.com/file/d/1jN72wLWiD_R-nyb-ry0W6oLpD9LY16Rv/view?usp=sharing)** | `30 min` | Create standard GKE cluster and enable Workload Identity |
| **[GCSFuse_Cluster](https://drive.google.com/file/d/19wrUxLJXTvxQqUjrmbE3bfO3EHhNuvZh/view?usp=sharing)** | `30 min` | Enable GCS Fuse CSI Driver on cluster |
| **[GCSFuse_Node](https://drive.google.com/file/d/1z2T3Al1JHzTSJB_VwrAz7C1XL636UfQw/view?usp=sharing)** | `10 min` | Enable GCS Fuse on node pools |
| **[Create_IP_Addresses](https://drive.google.com/file/d/1p-TYGfNnmxeVhxobTVmoXr5i7H9w-OZP/view?usp=sharing)** | `5 min` | Create static IP addresses and firewall rules |
| **[Create_Buckets](https://drive.google.com/file/d/194XKRYR4rNB7rdlhfhMxtLPWRdEgJKd1/view?usp=sharing)** | `6 min` | Create GCS buckets and configure permissions |

## 🚀 Deployment & Testing

| Video | Duration | Description |
|-------|----------|-------------|
| **[Deploy](https://drive.google.com/file/d/1Hz256McmAUep-yTbBIa0vW2W_aRTCxUK/view?usp=sharing)** | `10 min` | Google Cloud Marketplace deployment |
| **[Embed](https://drive.google.com/file/d/1_rlsF6Sequa8Mcf3NKY0yoXKZWTXZ8-o/view?usp=sharing)** | `Variable` | Upload and embed documents |
| **[Test](https://drive.google.com/file/d/1Vg5s7XBMkC2RF_xlPcRpUUaxW-G7F8em/view?usp=sharing)** | `5 min` | Test AI functionality with questions |

---

## ⚡ Deployment Sequence

| Step | Video | Duration | Purpose |
|------|-------|----------|---------|
| **1** | [Create_Cluster](https://drive.google.com/file/d/1jN72wLWiD_R-nyb-ry0W6oLpD9LY16Rv/view?usp=sharing) | `30 min` | Cluster + Identity |
| **2** | [GCSFuse_Cluster](https://drive.google.com/file/d/19wrUxLJXTvxQqUjrmbE3bfO3EHhNuvZh/view?usp=sharing) | `30 min` | Cluster GCS Fuse |
| **3** | [GCSFuse_Node](https://drive.google.com/file/d/1z2T3Al1JHzTSJB_VwrAz7C1XL636UfQw/view?usp=sharing) | `10 min` | Node GCS Fuse |
| **4** | [Create_IP_Addresses](https://drive.google.com/file/d/1p-TYGfNnmxeVhxobTVmoXr5i7H9w-OZP/view?usp=sharing) | `5 min` | Static IPs |
| **5** | [Create_Buckets](https://drive.google.com/file/d/194XKRYR4rNB7rdlhfhMxtLPWRdEgJKd1/view?usp=sharing) | `6 min` | GCS buckets |
| **6** | [Deploy](https://drive.google.com/file/d/1Hz256McmAUep-yTbBIa0vW2W_aRTCxUK/view?usp=sharing) | `10 min` | Marketplace deploy |
| **7** | ⏱️ **Wait 5 minutes** | — | Pod initialization |
| **8** | [Embed](https://drive.google.com/file/d/1_rlsF6Sequa8Mcf3NKY0yoXKZWTXZ8-o/view?usp=sharing) | `Variable` | Document processing |
| **9** | [Test](https://drive.google.com/file/d/1Vg5s7XBMkC2RF_xlPcRpUUaxW-G7F8em/view?usp=sharing) | `5 min` | Functionality test |

> **Total Time:** ~96 minutes + document processing

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

## 📚 Documentation Guides

- **[Cluster Setup Guide](cluster-setup.md)** — Step-by-step cluster configuration
- **[Network Configuration Guide](network-configuration.md)** — IP and firewall setup
- **[Storage Configuration Guide](storage-configuration.md)** — GCS bucket management
- **[Marketplace Deployment Guide](marketplace-deployment.md)** — Deploy from marketplace

---

<div align="center">

**📧 Support:** [support@aktus.ai](mailto:support@aktus.ai)  
**🐛 Issues:** [GitHub Issues](https://github.com/aktus-ai/aktus-platform-gcp-marketplace/issues)

*Follow the videos in sequence for complete deployment*

</div>

*Last Updated: May 2025*