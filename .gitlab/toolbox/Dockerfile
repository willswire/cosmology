FROM alpine

# Install package dependencies
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache \
    age \
    bash \
    curl \
    git \
    helm \
    sops \
    yq

# Install Zarf
RUN curl -L -o /usr/bin/zarf https://github.com/defenseunicorns/zarf/releases/download/v0.31.0/zarf_v0.31.0_Linux_amd64
RUN chmod +x /usr/bin/zarf
