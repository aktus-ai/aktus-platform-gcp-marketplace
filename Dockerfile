# root/Dockerfile

FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm/onbuild:latest

# Set metadata
COPY marketplace-annotations.yaml /data/marketplace-annotations.yaml

LABEL com.googleapis.cloudmarketplace.product.service.name="services/aktus-ai-platform.endpoints.aktus-ai-platform-public.cloud.goog"
LABEL com.google.cloudmarketplace.service.endpoint="services/aktus-ai-platform.endpoints.aktus-ai-platform-public.cloud.goog"
LABEL com.google.cloud.marketplace.service.endpoint="services/aktus-ai-platform.endpoints.aktus-ai-platform-public.cloud.goog"
LABEL com.google.cloud.marketplace.solution-version="1.0.3"
LABEL com.google.cloud.marketplace.partner-id="YL8mwhgO2T"
LABEL com.google.cloud.marketplace.solution-id="aktus-ai-platform"
LABEL maintainer="Aktus AI <support@aktus.ai>"

ENV WAIT_FOR_READY_TIMEOUT=1800
ENV TESTER_TIMEOUT=1800