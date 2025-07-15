# syntax=docker/dockerfile:1

ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS
FROM docker.io/library/alpine:3.22
ARG VERSION

LABEL internal.flatops.image.target_platform=$TARGETPLATFORM
LABEL internal.flatops.image.target_architecture=$TARGETARCH
LABEL internal.flatops.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="https://github.com/networkupstools/nut"

USER root

RUN \
    apk add --no-cache \
        catatonit \
        libusb \
        net-snmp \
        openssl \
    && \
    apk add --no-cache --virtual=.build-deps \
        asciidoc \
        autoconf \
        automake \
        g++ \
        gcc \
        git \
        libusb-dev \
        libtool \
        make \
        net-snmp-dev \
        openssl-dev \
        py3-pip \
        python3 \
    && \
    git clone https://github.com/networkupstools/nut.git /tmp/nut \
    && \
    cd /tmp/nut \
    && \
    git checkout "v${VERSION}" \
    && \
    ./autogen.sh \
    && \
    ./configure \
        --prefix=/usr \
        --sysconfdir=/etc/nut \
        --localstatedir=/var \
        --with-usb \
        --with-snmp \
        --with-ssl \
        --without-doc \
        --disable-static \
    && \
    make && make install \
    && \
    apk del --purge .build-deps \
    && \
    rm -rf /tmp/*

COPY . /

USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]