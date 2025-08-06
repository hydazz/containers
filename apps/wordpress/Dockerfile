# syntax=docker/dockerfile:1

# renovate: datasource=docker depName=wordpress versioning=docker
FROM wordpress:6.8.2-fpm-alpine@sha256:05602063913595b224934f4b0ef3c4b1ec853461815f51aa161471f8e942a88a

# Install PHP extensions
RUN \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        bzip2-dev \
        gettext-dev \
        gmp-dev \
        libxml2-dev \
        tidyhtml-dev \
        libxslt-dev \
    && \
    docker-php-ext-install -j$(nproc) \
        bz2 \
        gettext \
        gmp \
        pcntl \
        soap \
        tidy \
        xsl \
    && \
    pecl install redis \
    && \
    docker-php-ext-enable redis \
    && \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && \
    apk add --virtual .php-ext-rundeps $runDeps \
    && \
    apk del .build-deps