FROM alpine:3.19.1

# Add testing repo
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Add community repo
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Install packages
RUN apk add --no-cache \
    age \
    bash \
    curl \
    git \
    helm \
    sops \
    yq \
    zarf
