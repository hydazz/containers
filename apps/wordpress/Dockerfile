# syntax=docker/dockerfile:1

# renovate: datasource=docker depName=wordpress versioning=docker
FROM docker.io/library/wordpress:7.0.2-php8.4@sha256:b87aba3079ad6ffb50d4f320a2f2ca945b684c8a38bd54ff032c9a02f4461a67

# renovate: datasource=github-releases depName=wp-cli/wp-cli
ENV WORDPRESS_CLI_VERSION=2.12.0

# Install PHP extensions
RUN \
    apt-get update \
    && \
    apt-get install -y --no-install-recommends \
        libbz2-dev \
        libgmp-dev \
        libtidy-dev \
        libxslt1-dev \
        libtidy58 \
        libxslt1.1 \
    && \
    docker-php-ext-install -j$(nproc) \
        bz2 \
        gettext \
        gmp \
        pcntl \
        soap \
        tidy \
        xsl \
    \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && rm -r /tmp/pear \
    && \
    apt-get purge -y --auto-remove \
        libbz2-dev \
        libgmp-dev \
        libtidy-dev \
        libxslt1-dev \
    && \
    rm -rf /var/lib/apt/lists/*

# Add WP-CLI and clean up default plugins and themes
RUN \
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