FROM debian:trixie-slim

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