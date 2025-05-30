# Network Configuration

# Step 2: Network Configuration

Create external static IP addresses for all Aktus AI Platform services.

## Prerequisites

- Completed Step 1 (Cluster Setup)
- Google Cloud SDK configured

## Commands

### Environment Setup
```bash
export PROJECT_ID="your-project-id"
export REGION="us-central1"
```

### Create Static IP Addresses
```bash
# Research Service Static IP
gcloud compute addresses create aktus-research-service-ip \
  --region=$REGION \
  --project=$PROJECT_ID

# Database Service Static IP
gcloud compute addresses create aktus-database-service-ip \
  --region=$REGION \
  --project=$PROJECT_ID

# Embedding Service Static IP
gcloud compute addresses create aktus-embedding-service-ip \
  --region=$REGION \
  --project=$PROJECT_ID

# Knowledge Assistant Static IP
gcloud compute addresses create aktus-knowledge-assistant-ip \
  --region=$REGION \
  --project=$PROJECT_ID
```

### Get IP Addresses
```bash
export RESEARCH_IP=$(gcloud compute addresses describe aktus-research-service-ip --region=$REGION --format="value(address)")
export DATABASE_IP=$(gcloud compute addresses describe aktus-database-service-ip --region=$REGION --format="value(address)")
export EMBEDDING_IP=$(gcloud compute addresses describe aktus-embedding-service-ip --region=$REGION --format="value(address)")
export KNOWLEDGE_ASSISTANT_IP=$(gcloud compute addresses describe aktus-knowledge-assistant-ip --region=$REGION --format="value(address)")

echo "Research Service IP: $RESEARCH_IP"
echo "Database Service IP: $DATABASE_IP"
echo "Embedding Service IP: $EMBEDDING_IP"
echo "Knowledge Assistant IP: $KNOWLEDGE_ASSISTANT_IP"
```

### Create Firewall Rules
```bash
gcloud compute firewall-rules create aktus-research-allow-8080 \
  --allow tcp:8080 \
  --source-ranges 0.0.0.0/0 \
  --project=$PROJECT_ID

gcloud compute firewall-rules create aktus-database-allow-5432 \
  --allow tcp:5432 \
  --source-ranges 0.0.0.0/0 \
  --project=$PROJECT_ID

gcloud compute firewall-rules create aktus-embedding-allow-8000 \
  --allow tcp:8000 \
  --source-ranges 0.0.0.0/0 \
  --project=$PROJECT_ID

gcloud compute firewall-rules create aktus-knowledge-assistant-allow-3000 \
  --allow tcp:3000 \
  --source-ranges 0.0.0.0/0 \
  --project=$PROJECT_ID
```

### Verification
```bash
gcloud compute addresses list --filter="region:$REGION" --project=$PROJECT_ID
gcloud compute firewall-rules list --filter="name~aktus" --project=$PROJECT_ID
```

## Next Steps

📍 **[Step 3: Storage Configuration](storage-configuration.md)**