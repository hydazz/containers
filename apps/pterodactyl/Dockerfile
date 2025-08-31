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
    mkdir -p /app/var && \
    chown -R nobody:nogroup /app \
    && \
    # https://github.com/docker-library/wordpress/blob/bdaac32b48f6a240225247bb4318c94eaef2826d/latest/php8.4/fpm-alpine/Dockerfile#L88-L100
    { \
		echo 'error_reporting = E_ERROR | E_WARNING | E_PARSE | E_CORE_ERROR | E_CORE_WARNING | E_COMPILE_ERROR | E_COMPILE_WARNING | E_RECOVERABLE_ERROR'; \
		echo 'display_errors = Off'; \
		echo 'display_startup_errors = Off'; \
		echo 'log_errors = On'; \
		echo 'error_log = /dev/stderr'; \
		echo 'log_errors_max_len = 1024'; \
		echo 'ignore_repeated_errors = On'; \
		echo 'ignore_repeated_source = Off'; \
		echo 'html_errors = Off'; \
	} > /usr/local/etc/php/conf.d/error-logging.ini \
    && \
    # Fix pterodactyl's ungraceful overwriting of the php-fpm.conf
    cp /usr/local/etc/php-fpm.conf /usr/local/etc/php-fpm.d/pterodactyl.conf \
	&& cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf \
	&& sed -i 's|include=NONE/etc/php-fpm.d/\*.conf|include=etc/php-fpm.d/*.conf|' /usr/local/etc/php-fpm.conf \
    && \
    rm -rf /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /app
VOLUME ["/app/var"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
CMD ["php-fpm", "--nodaemonize"]