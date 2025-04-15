FROM debian:bullseye-slim

# Install basic utilities and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    postgresql-client \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install grpcurl manually (x86_64 version)
RUN wget https://github.com/fullstorydev/grpcurl/releases/download/v1.8.7/grpcurl_1.8.7_linux_x86_64.tar.gz && \
    tar -xzf grpcurl_1.8.7_linux_x86_64.tar.gz && \
    chmod +x grpcurl && \
    mv grpcurl /usr/local/bin/ && \
    rm grpcurl_1.8.7_linux_x86_64.tar.gz

# Copy test script
COPY test.sh /test.sh
RUN chmod +x /test.sh

CMD ["/test.sh"]