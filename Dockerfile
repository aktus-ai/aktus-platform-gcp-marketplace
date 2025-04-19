# root/Dockerfile

FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm/onbuild

# Set metadata
LABEL maintainer="Aktus AI <support@aktus.ai>"
LABEL com.googleapis.cloudmarketplace.product.service.name="services/aktus-ai-platform"

# Set environment variables
ENV WAIT_FOR_READY_TIMEOUT 1800
ENV TESTER_TIMEOUT 1800