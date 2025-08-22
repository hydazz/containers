# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-alpine3.22
ARG VERSION

ENV \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

ENV IGNORE_CAMERAS="" \
    RCLONE_CONFIG=/config/rclone.conf \
    RCLONE_DESTINATION=local:/data \
    RCLONE_RETENTION=7d \
    SQLITE_PATH=/config/events.sqlite \
    UFP_ADDRESS=127.0.0.1 \
    UFP_PASSWORD=unifi_protect_password \
    UFP_PORT=443 \
    UFP_SSL_VERIFY=true \
    UFP_USERNAME=unifi_protect_user \
    VERBOSITY="v" \
    XDG_CACHE_HOME=/config \
    XDG_CONFIG_HOME=/config

USER root

RUN \
    apk add --no-cache \
        bash \
        catatonit \
        rclone \
        ffmpeg \
    && \
    pip3 install \
        "unifi-protect-backup==${VERSION}" \
    && \
    rm -rf /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]
VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]