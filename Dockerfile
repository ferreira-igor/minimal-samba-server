FROM debian:trixie-slim

LABEL org.opencontainers.image.title="Minimal Samba Server"

LABEL org.opencontainers.image.description="A lightweight and secure Samba server for Docker with automatic user provisioning through environment variables."

LABEL org.opencontainers.image.source="https://github.com/ferreira-igor/minimal-samba-server"

LABEL org.opencontainers.image.licenses="GPL-3.0"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        samba \
        samba-common-bin \
        tini \
        bash \
        grep \
        coreutils && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/samba

COPY smb.conf /etc/samba/smb.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 445/tcp

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
