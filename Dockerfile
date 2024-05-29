FROM alpine:3.18 as builder

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk --no-cache add \
        curl=8.5.0-r0 \
    && LATEST_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt) \
    && curl -LO "https://dl.k8s.io/release/$LATEST_VERSION/bin/linux/amd64/kubectl" \
    && curl -LO "https://dl.k8s.io/release/$LATEST_VERSION/bin/linux/amd64/kubectl.sha256" \
    && echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm -rf \
        kubectl \
        kubectl.sha256 \
    && apk --no-cache del \
        curl \
    && rm -rf /var/cache/apk/*

CMD ["kubectl"]

FROM builder as local

LABEL repository="https://github.com/text-adi/kubectl"
LABEL homepage="https://github.com/text-adi"
LABEL maintainer="text-adi <text-adi@github.com>"