# Network Configuration

# Step 2: Network Configuration

This guide covers creating external static IP addresses required for all Aktus AI Platform services.

## 🎥 Video Guide

📹 **[Watch Step 2 Installation Video](../videos/step2-network-config.md)**

---

## Prerequisites

- Completed [Step 1: Cluster Setup & Identity Configuration](cluster-setup.md)
- Google Cloud SDK configured
- Project with Compute Engine API enabled

---

## Network Configuration Overview

Step 2 creates **4 external static IP addresses** for:
1. ✅ Research Service (WebSocket backend)
2. ✅ Database Service (PostgreSQL access)
3. ✅ Embedding Service (Vector embeddings)
4. ✅ Knowledge Assistant (Frontend interface)

---

## Required Static IP Addresses

### Set Environment Variables

Use the same variables from Step 1:

```bash
# If you're in a new terminal session, set these again
export PROJECT_ID="your-project-id"
export REGION="us-central1"  # Must match your cluster region
```

### Create Static IP Addresses

Create all 4 required static IP addresses:

```bash
# 1. Research Service Static IP
gcloud compute addresses create aktus-research-service-ip \
  --region=$REGION \
  --project=$PROJECT_ID

# 2. Database Service Static IP
gcloud compute addresses create aktus-database-service-ip \
  --region=$REGION \
  --project=$PROJECT_ID

# 3. Embedding Service Static IP
gcloud compute addresses create aktus-embedding-service-ip \
  --region=$REGION \
  --project=$PROJECT_ID

# 4. Knowledge Assistant Static IP
gcloud compute addresses create aktus-knowledge-assistant-ip \
  --region=$REGION \
  --project=$PROJECT_ID
```

---

## Verify IP Creation

### List All Created IPs

```bash
gcloud compute addresses list --filter="region:$REGION" --project=$PROJECT_ID
```

### Get Individual IP Addresses

```bash
# Research Service IP
export RESEARCH_IP=$(gcloud compute addresses describe aktus-research-service-ip --region=$REGION --format="value(address)")

# Database Service IP
export DATABASE_IP=$(gcloud compute addresses describe aktus-database-service-ip --region=$REGION --format="value(address)")

# Embedding Service IP
export EMBEDDING_IP=$(gcloud compute addresses describe aktus-embedding-service-ip --region=$REGION --format="value(address)")

# Knowledge Assistant IP
export KNOWLEDGE_ASSISTANT_IP=$(gcloud compute addresses describe aktus-knowledge-assistant-ip --region=$REGION --format="value(address)")
```

### Display All IP Addresses

```bash
echo "=== Static IP Addresses Created ==="
echo "Research Service IP: $RESEARCH_IP"
echo "Database Service IP: $DATABASE_IP"
echo "Embedding Service IP: $EMBEDDING_IP"
echo "Knowledge Assistant IP: $KNOWLEDGE_ASSISTANT_IP"
echo "=================================="
```

---

## Save IP Addresses for Deployment

**📝 Important:** Copy these IP addresses for use in the Google Cloud Marketplace deployment form (Step 4).

### Copy to Clipboard (macOS)

```bash
echo "Research Service IP: $RESEARCH_IP
Database Service IP: $DATABASE_IP
Embedding Service IP: $EMBEDDING_IP
Knowledge Assistant IP: $KNOWLEDGE_ASSISTANT_IP" | pbcopy
```

### Copy to Clipboard (Linux)

```bash
echo "Research Service IP: $RESEARCH_IP
Database Service IP: $DATABASE_IP
Embedding Service IP: $EMBEDDING_IP
Knowledge Assistant IP: $KNOWLEDGE_ASSISTANT_IP" | xclip -selection clipboard
```

### Save to File

```bash
cat > static-ips.txt << EOF
# Aktus AI Platform Static IP Addresses
# Region: $REGION
# Created: $(date)

Research Service IP: $RESEARCH_IP
Database Service IP: $DATABASE_IP
Embedding Service IP: $EMBEDDING_IP
Knowledge Assistant IP: $KNOWLEDGE_ASSISTANT_IP
EOF

echo "IP addresses saved to static-ips.txt"
```

---

## Firewall Configuration

### Create Firewall Rules

Create firewall rules to allow traffic to your services:

```bash
# Allow HTTP/HTTPS traffic to Research Service (port 8080)
gcloud compute firewall-rules create aktus-research-allow-8080 \
  --allow tcp:8080 \
  --source-ranges 0.0.0.0/0 \
  --description "Allow HTTP traffic to Research Service" \
  --project=$PROJECT_ID

# Allow traffic to Database Service (port 5432)
gcloud compute firewall-rules create aktus-database-allow-5432 \
  --allow tcp:5432 \
  --source-ranges 0.0.0.0/0 \
  --description "Allow traffic to Database Service" \
  --project=$PROJECT_ID

# Allow HTTP traffic to Embedding Service (port 8000)
gcloud compute firewall-rules create aktus-embedding-allow-8000 \
  --allow tcp:8000 \
  --source-ranges 0.0.0.0/0 \
  --description "Allow HTTP traffic to Embedding Service" \
  --project=$PROJECT_ID

# Allow HTTP traffic to Knowledge Assistant (port 3000)
gcloud compute firewall-rules create aktus-knowledge-assistant-allow-3000 \
  --allow tcp:3000 \
  --source-ranges 0.0.0.0/0 \
  --description "Allow HTTP traffic to Knowledge Assistant" \
  --project=$PROJECT_ID
```

### Verify Firewall Rules

```bash
gcloud compute firewall-rules list --filter="name~aktus" --project=$PROJECT_ID
```

---

## Network Security Considerations

### Production Recommendations

For production deployments, consider:

1. **Restrict Source Ranges**: Instead of `0.0.0.0/0`, use specific IP ranges
2. **VPC Firewall Rules**: Use VPC-specific firewall rules
3. **Cloud Load Balancer**: Use Google Cloud Load Balancer for HTTPS termination
4. **Cloud Armor**: Enable DDoS protection and WAF

### Example Restricted Firewall Rule

```bash
# Example: Allow only from your corporate network
gcloud compute firewall-rules create aktus-research-allow-8080-restricted \
  --allow tcp:8080 \
  --source-ranges 203.0.113.0/24 \  # Replace with your IP range
  --description "Allow HTTP traffic to Research Service from corporate network" \
  --project=$PROJECT_ID
```

---

## Testing Network Connectivity

### Test IP Address Allocation

```bash
# Test if IP addresses are properly allocated
for ip in $RESEARCH_IP $DATABASE_IP $EMBEDDING_IP $KNOWLEDGE_ASSISTANT_IP; do
  echo "Testing IP: $ip"
  ping -c 1 $ip || echo "IP $ip not yet active (this is normal before deployment)"
done
```

---

## Troubleshooting

### Common Issues

**Issue:** "IP address already exists"  
**Solution:** 
```bash
# Check if IP already exists
gcloud compute addresses list --filter="name~aktus" --project=$PROJECT_ID
# Delete existing IP if needed
gcloud compute addresses delete aktus-research-service-ip --region=$REGION --project=$PROJECT_ID
```

**Issue:** "Quota exceeded for static IP addresses"  
**Solution:**
1. Check your quota: `gcloud compute project-info describe --project=$PROJECT_ID`
2. Request quota increase in Google Cloud Console
3. Or delete unused static IPs: `gcloud compute addresses list`

**Issue:** "Region mismatch"  
**Solution:** Ensure the region matches your GKE cluster region from Step 1.

---

## Environment Variables for Next Steps

Save these for Step 3 and Step 4:

```bash
echo "=== Environment Variables for Next Steps ==="
echo "export PROJECT_ID=$PROJECT_ID"
echo "export REGION=$REGION"
echo "export RESEARCH_IP=$RESEARCH_IP"
echo "export DATABASE_IP=$DATABASE_IP"
echo "export EMBEDDING_IP=$EMBEDDING_IP"
echo "export KNOWLEDGE_ASSISTANT_IP=$KNOWLEDGE_ASSISTANT_IP"
```

---

## Next Steps

After completing Step 2, proceed to:

📍 **[Step 3: Storage Configuration](storage-configuration.md)** - Create GCS buckets

---

## Additional Resources

- [Reserving Static External IP Addresses](https://cloud.google.com/compute/docs/ip-addresses/reserve-static-external-ip-address)
- [VPC Firewall Rules](https://cloud.google.com/vpc/docs/firewalls)
- [Google Cloud Load Balancer](https://cloud.google.com/load-balancing)
- [Network Security Best Practices](https://cloud.google.com/security/best-practices)