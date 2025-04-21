FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    curl \
    postgresql-client \
    wget \
    unzip \
    dnsutils \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/fullstorydev/grpcurl/releases/download/v1.8.7/grpcurl_1.8.7_linux_x86_64.tar.gz && \
    tar -xzf grpcurl_1.8.7_linux_x86_64.tar.gz && \
    chmod +x grpcurl && \
    mv grpcurl /usr/local/bin/ && \
    rm grpcurl_1.8.7_linux_x86_64.tar.gz

COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh

COPY test.sh /test.sh
RUN chmod +x /test.sh

CMD ["/test.sh"]