## Overview
Aktus AI Platform is an enterprise AI platform that enables organizations to build and deploy AI solutions for research, knowledge management, and data processing. The platform integrates multiple services to provide a comprehensive AI development and deployment environment.

## Components
- Research Service: Web interface for research and knowledge exploration
- Inference Service: ML model inference with GPU acceleration
- Database Service: Data management and storage
- Multimodal Data Ingestion Service: Document and image processing
- Embedding Service: Vector embeddings for semantic search

## One-time Setup

### Prerequisites
- Kubernetes cluster with version >= 1.19
- `kubectl` command-line tool
- Helm 3.0 or later

### Install the Application CRD
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/application/master/config/crd/bases/app.k8s.io_applications.yaml
```

#### Installing the application from Google Cloud Marketplace

1. Navigate to the Aktus AI Platform page in Google Cloud Marketplace
2. Click "Configure"
3. Set your configuration parameters
4. Deploy the application

#### Installing via Helm
```bash
# Add the Aktus repo
helm repo add aktus https://charts.aktus.ai

# Install the chart
helm install aktus-platform aktus/aktus-platform \
  --namespace aktus \
  --create-namespace \
  --set name=aktus-platform \
  --set serviceAccount.name=aktus-platform-sa
```

### Basic Usage
#### Accessing the Research Service 
The Research Service provides a web interface at: `http://<external-ip>:8080`. 

To get the external IP: 
```bash
kubectl get svc aktus-research -n <namespace>
```

#### Default Credentials
The default login credentials are:

```
Username: guest
Password: guest
```

### Backup and Restore 
#### Backing up PostgreSQL Data
```bash
kubectl exec -n <namespace> aktus-postgres-0 -- pg_dump -U <username> <database> > backup.sql
```

#### Restoring PostgreSQL Data
```bash
kubectl cp backup.sql <namespace>/aktus-postgres-0:/tmp/
kubectl exec -n <namespace> aktus-postgres-0 -- psql -U <username> <database> -f /tmp/backup.sql
```

### Image Updates
To update to a newer version:
```bash
helm upgrade aktus-platform aktus/aktus-platform \
  --namespace <namespace> \
  --set imageTag=<new-version>
```

### Scaling
The Inference Service can be scaled by adjusting the number of replicas:
```bash
kubectl scale deployment aktus-inference -n <namespace> --replicas=2
```

### Delete the Application
To delete the application:
```bash
helm delete aktus-platform -n <namespace>
```

Some persistent volumes may remain. To clean them up:
```bash
kubectl delete pvc -l app.kubernetes.io/name=aktus-platform -n <namespace>
```

## API Documentation
TBD.


## Billing (In Progress)

### Step 1: Create a ubbagent config file

Create `charts/aktus-platform/templates/ubbagent-config.yaml`:

```yaml
{{- if .Values.version }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-ubbagent-config
  labels:
    app.kubernetes.io/name: {{ .Release.Name }}
data:
  config.yaml: |-
    # The identity section contains authentication information used by the agent.
    identities:
    - name: gcp
      gcp:
        # This parameter accepts a base64-encoded JSON service account key.
        # It can be generated from the reporting-secret directly.
        encodedServiceAccountKey: ${reporting_key}

    # The metrics section defines the metrics that will be reported.
    metrics:
    - name: aktus_processing_time
      type: int
      endpoints:
      - name: servicecontrol
      aggregation:
        bufferSeconds: 60
      monitoredResource: {{"{"}}gcp_kubernetes_engine_service{{"}"}}

    # The endpoints section defines where metrics are reported to.
    endpoints:
    - name: servicecontrol
      servicecontrol:
        identity: gcp
        serviceName: ${service_name}
        consumerId: ${consumer_id}

    # The agent section configures operational aspects of the agent.
    agent:
      reportingInterval: 60s
      onError: retry
      endpointsCache:
        expirationTime: 1m
      endpoint_overrides: {}
{{- end }}
```
