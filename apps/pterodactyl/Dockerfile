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
    mkdir -p /app/var /usr/local/var/log && \
    chown -R nobody:nogroup /app /usr/local/var/log \
    && \
    rm -rf /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /app
VOLUME ["/app/var"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
CMD ["php-fpm", "--nodaemonize"]