# syntax=docker/dockerfile:1

# renovate: datasource=docker depName=wordpress versioning=docker
FROM wordpress:6.8.2-php8.4-fpm-alpine@sha256:99aa6a047b794445cf3b14fa3243b93637d639420f150a915ddff9a17d2cea6e

# renovate: datasource=github-releases depName=wp-cli/wp-cli
ENV WORDPRESS_CLI_VERSION 2.11.0

RUN \
    apk add --no-cache \
        rsync \
    && \
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
    apk del .build-deps \
    && \
    curl -o /usr/local/bin/wp -fL "https://github.com/wp-cli/wp-cli/releases/download/v${WORDPRESS_CLI_VERSION}/wp-cli-${WORDPRESS_CLI_VERSION}.phar" \
    && \
    chmod +x /usr/local/bin/wp \
    && \
    find /usr/src/wordpress/wp-content/plugins -mindepth 1 -maxdepth 1 -not -name 'index.php' -exec rm -rf {} + \
    && \
    LATEST_THEME=$(ls -1t /usr/src/wordpress/wp-content/themes/ | grep -v 'index.php' | head -n1) \
    && \
    find /usr/src/wordpress/wp-content/themes -mindepth 1 -maxdepth 1 -not -name 'index.php' -not -name "$LATEST_THEME" -exec rm -rf {} +

COPY defaults/mu-plugins /usr/src/wordpress/wp-content/mu-plugins