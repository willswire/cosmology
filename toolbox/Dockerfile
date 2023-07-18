FROM --platform=linux/amd64 alpine

# Install package dependencies
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache \
    age \
    bash \
    curl \
    git \
    sops \
    yq

# Install Zarf
RUN curl -L -o /usr/bin/zarf https://github.com/defenseunicorns/zarf/releases/download/v0.28.2/zarf_v0.28.2_Linux_amd64
RUN chmod +x /usr/bin/zarf