# root/Dockerfile

FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm/onbuild

COPY schema.yaml /data/schema.yaml
COPY chart/ /data/chart/
COPY apptest/ /data-test/

# Set metadata
LABEL maintainer="Aktus AI <support@aktus.ai>"

# Set environment variables
ENV WAIT_FOR_READY_TIMEOUT 1800
ENV TESTER_TIMEOUT 1800