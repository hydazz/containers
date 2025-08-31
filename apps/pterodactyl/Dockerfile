# syntax=docker/dockerfile:1

ARG VERSION
FROM ghcr.io/pterodactyl/panel:${VERSION}

USER root

RUN \
    apk add --no-cache \
        catatonit \
        bash \
    && \
    apk del --purge --no-cache \
        nginx \
        supervisor \
        certbot \
        certbot-nginx \
    && \
    rm -rf /tmp/*

COPY . /

WORKDIR /app
VOLUME ["/app/var"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
CMD ["php-fpm", "--nodaemonize"]