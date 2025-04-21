# root/Dockerfile

FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm/onbuild

# Set metadata
LABEL maintainer="Aktus AI <support@aktus.ai>"
LABEL com.google.cloud.marketplace.solution-version="1.0.0"
LABEL com.google.cloud.marketplace.partner-id="YL8mwhgO2T"
LABEL com.googleapis.cloudmarketplace.product.service.name=services/aktus-ai-platform.endpoints.aktus-ai-platform-public.cloud.goog

# Set environment variables
ENV WAIT_FOR_READY_TIMEOUT 1800
ENV TESTER_TIMEOUT 1800