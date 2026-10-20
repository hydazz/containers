# syntax=docker/dockerfile:1

FROM docker.io/library/debian:13-slim AS probe
ARG VERSION

WORKDIR /tmp

# Extract rather than install: the maintainer scripts set up a systemd service and a dedicated user.
RUN \
    apt-get update \
    && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
    && \
    curl -fsSL -o /usr/share/keyrings/paessler.asc https://packages.paessler.com/keys/paessler.asc \
    && \
    echo "deb [signed-by=/usr/share/keyrings/paessler.asc] https://packages.paessler.com/apt $(. /etc/os-release && echo "${VERSION_CODENAME}") main" \
        > /etc/apt/sources.list.d/paessler.list \
    && \
    apt-get update \
    && \
    apt-get download "prtgmpprobe=${VERSION}" \
    && \
    dpkg-deb --extract prtgmpprobe_*.deb /rootfs \
    && \
    mkdir -p /rootfs/opt/paessler/share/scripts

FROM docker.io/library/debian:13-slim

# The SNMP and Cisco modules unpack their own OpenSSL into $HOME/.local/lib when they load.
ENV \
    HOME=/tmp \
    PRTGMPPROBE__MOMO__DIR=/opt/paessler/mpprobe/monitoringmodules

RUN \
    apt-get update \
    && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        catatonit \
        python3-minimal \
    && \
    rm -rf /var/lib/apt/lists/*

COPY --from=probe /rootfs/opt/paessler /opt/paessler

# Ping sensors need root with NET_RAW and NET_ADMIN: the ICMP module only opens raw sockets.
USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/opt/paessler/mpprobe/prtgmpprobe"]
