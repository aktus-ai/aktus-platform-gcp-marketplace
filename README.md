# Aktus AI Platform
**Enterprise AI for Research, Knowledge Management, and Data Processing**

Welcome to the Aktus AI Platform—a comprehensive enterprise solution to build, deploy, and manage AI services. This package is available on Google Cloud Marketplace for streamlined deployment.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Google Cloud Marketplace Deployment](#deploying-from-google-cloud-marketplace)
  - [Helm Installation](#installing-via-helm)
- [Usage](#usage)
  - [Accessing the Research Service](#accessing-the-research-service)
  - [Default Credentials](#default-credentials)
- [Backup and Restore](#backup-and-restore)
- [Updating and Scaling](#updating-and-scaling)
- [Deleting the Application](#deleting-the-application)
- [Billing (Work in Progress)](#billing)
- [API Documentation](#api-documentation)
- [Troubleshooting & FAQ](#troubleshooting--faq)

---

## Overview

Aktus AI Platform empowers organizations with a unified interface and robust backend to conduct AI research, deploy models with GPU acceleration, manage databases, and process multimodal data. Whether you are exploring semantic search via embeddings or running intensive inference tasks, our platform is designed for high availability and performance.

---

## Features

- **Research Service:** A web interface for research and knowledge exploration.  
- **Inference Service:** Machine learning model inference with GPU acceleration.  
- **Database Service:** Robust data management and storage solutions.  
- **Multimodal Data Ingestion:** Process documents and images efficiently.  
- **Embedding Service:** Generate vector embeddings for semantic searches.

---

## Prerequisites

- **Kubernetes:** Cluster version 1.19 or higher is required.
- **kubectl:** Command-line tool for Kubernetes operations.
- **Helm:** Version 3.0 or later.
- **Application CRD:** Install the required Custom Resource Definition.

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/application/master/config/crd/bases/app.k8s.io_applications.yaml
```

---

## Installation

### Deploying from Google Cloud Marketplace

1. Open the [Aktus AI Platform page](#) in Google Cloud Marketplace.
2. Click **Configure**.
3. Set your desired configuration parameters.
4. Click **Deploy** to launch the application.

### Installing via Helm

For those preferring Helm, follow these steps:

```bash
# Add the Aktus helm repository
helm repo add aktus https://charts.aktus.ai

# Install the Aktus Platform chart
helm install aktus-platform aktus/aktus-platform \
  --namespace aktus \
  --create-namespace \
  --set name=aktus-platform \
  --set serviceAccount.name=aktus-platform-sa
```

---

## Usage

### Accessing the Research Service

After deployment, access the Research Service via your browser:

```
http://<external-ip>:8080
```

To retrieve the external IP:

```bash
kubectl get svc aktus-research -n <namespace>
```

### Default Credentials

- **Username:** guest  
- **Password:** guest

> **Note:** It is recommended to change these credentials for production environments.

---

## Backup and Restore

### Backing Up PostgreSQL Data

Use the following command to create a backup:

```bash
kubectl exec -n <namespace> aktus-postgres-0 -- pg_dump -U <username> <database> > backup.sql
```

### Restoring PostgreSQL Data

Restore your database backup with:

```bash
kubectl cp backup.sql <namespace>/aktus-postgres-0:/tmp/
kubectl exec -n <namespace> aktus-postgres-0 -- psql -U <username> <database> -f /tmp/backup.sql
```

---

## Updating and Scaling

### Image Updates

To update the platform to a newer version:

```bash
helm upgrade aktus-platform aktus/aktus-platform \
  --namespace <namespace> \
  --set imageTag=<new-version>
```

### Scaling Inference Service

Adjust the number of replicas for the Inference Service:

```bash
kubectl scale deployment aktus-inference -n <namespace> --replicas=2
```

---

## Deleting the Application

To remove the application:

```bash
helm delete aktus-platform -n <namespace>
```

Cleanup any residual persistent volumes:

```bash
kubectl delete pvc -l app.kubernetes.io/name=aktus-platform -n <namespace>
```

---

## Billing

### Ubbagent Configuration (Work in Progress)

Create the configuration file `charts/aktus-platform/templates/ubbagent-config.yaml`:

```yaml
{{- if .Values.商业版 }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-ubbagent-config
  labels:
    app.kubernetes.io/name: {{ .Release.Name }}
data:
  config.yaml: |-
    # Identity section for agent authentication
    identities:
    - name: gcp
      gcp:
        # Provide a base64-encoded JSON service account key here.
        encodedServiceAccountKey: ${reporting_key}

    # Define metrics that will be reported.
    metrics:
    - name: aktus_processing_time
      type: int
      endpoints:
      - name: servicecontrol
      aggregation:
        bufferSeconds: 60
      monitoredResource: {{"{"}}gcp_kubernetes_engine_service{{"}"}}

    # Reporting endpoints configuration.
    endpoints:
    - name: servicecontrol
      servicecontrol:
        identity: gcp
        serviceName: ${service_name}
        consumerId: ${consumer_id}

    # Agent operational settings.
    agent:
      reportingInterval: 60s
      onError: retry
      endpointsCache:
        expirationTime: 1m
      endpoint_overrides: {}
{{- end }}
```

> **Note:** Billing integration is under active development. Please refer back for updates or consult our support team for guidance.

---

## API Documentation

*API documentation is in progress. Stay tuned for updates or visit our [documentation portal](#) for the latest information.*

---

## Troubleshooting & FAQ

- **Issue:** Cannot access the Research Service.  
  **Solution:** Ensure your Kubernetes service has an external IP assigned using `kubectl get svc aktus-research -n <namespace>`.

- **Issue:** Backup/Restore commands fail.  
  **Solution:** Verify correct credentials and namespace are provided. Also, review PostgreSQL logs for more detail.

- **For Further Help:** Contact our support or refer to our [community forum](#).

---

## Conclusion

This README provides comprehensive guidance for deploying, using, and managing the Aktus AI Platform on Google Cloud Marketplace. For further inquiries or custom deployment requirements, please contact our [support](mailto:support@aktus.ai) team or refer to our online documentation.
