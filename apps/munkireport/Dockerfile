# syntax=docker/dockerfile:1

# renovate: datasource=docker depName=composer versioning=docker
FROM composer:2 AS composer

# renovate: datasource=docker depName=php versioning=docker
FROM php:8.5-apache

ARG VERSION

ENV PHP_MEMORY_LIMIT=256M
ENV PHP_UPLOAD_LIMIT=256M

RUN set -ex; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        dpkg-dev \
        git \
        libldap2-dev \
        libsqlite3-dev \
        libxml2-dev \
        libzip-dev \
        unzip \
    ; \
    debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
    docker-php-ext-configure ldap --with-libdir="lib/$debMultiarch"; \
    docker-php-ext-install -j "$(nproc)" \
        ldap \
        pdo_mysql \
        pdo_sqlite \
        soap \
        zip \
    ; \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    apt-mark manual git unzip; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); print so }' \
        | sort -u \
        | xargs -rt dpkg-query --search \
        | awk 'sub(":$", "", $1) { print $1 }' \
        | sort -u \
        | xargs -rt apt-mark manual; \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.revalidate_freq=60'; \
    } > "$PHP_INI_DIR/conf.d/opcache-recommended.ini"; \
    \
    { \
        echo 'memory_limit=${PHP_MEMORY_LIMIT}'; \
        echo 'upload_max_filesize=${PHP_UPLOAD_LIMIT}'; \
        echo 'post_max_size=${PHP_UPLOAD_LIMIT}'; \
    } > "$PHP_INI_DIR/conf.d/munkireport.ini"

ENV APACHE_BODY_LIMIT=268435456

RUN a2enmod headers remoteip rewrite; \
    \
    { \
        echo 'RemoteIPHeader X-Real-IP'; \
        echo 'RemoteIPInternalProxy 10.0.0.0/8'; \
        echo 'RemoteIPInternalProxy 172.16.0.0/12'; \
        echo 'RemoteIPInternalProxy 192.168.0.0/16'; \
    } > /etc/apache2/conf-available/remoteip.conf; \
    a2enconf remoteip; \
    \
    { \
        echo 'LimitRequestBody ${APACHE_BODY_LIMIT}'; \
    } > /etc/apache2/conf-available/apache-limits.conf; \
    a2enconf apache-limits; \
    \
    sed -i 's|DocumentRoot /var/www/html$|DocumentRoot /var/www/html/public|' \
        /etc/apache2/sites-available/000-default.conf \
        /etc/apache2/sites-available/default-ssl.conf; \
    \
    { \
        echo '<Directory /var/www/html/public>'; \
        echo '    AllowOverride All'; \
        echo '</Directory>'; \
    } > /etc/apache2/conf-available/munkireport-dir.conf; \
    a2enconf munkireport-dir

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN set -ex; \
    curl -fsSL -o /tmp/munkireport.tar.gz \
        "https://github.com/munkireport/munkireport-php/archive/refs/tags/${VERSION}.tar.gz"; \
    mkdir -p /usr/src/munkireport; \
    tar -xzf /tmp/munkireport.tar.gz --strip-components=1 -C /usr/src/munkireport; \
    chown -R www-data:www-data /usr/src/munkireport; \
    # Enable the merge-plugin so composer.local.json overlays work
    sed -i 's|"wikimedia/composer-merge-plugin": false|"wikimedia/composer-merge-plugin": true|' \
        /usr/src/munkireport/composer.json; \
    rm -f /tmp/munkireport.tar.gz

ENV \
    AUTH_METHODS="NOAUTH" \
    CONNECTION_DRIVER="sqlite" \
    INDEX_PAGE="" \
    MODULES="ard,bluetooth,disk_report,filevault_status,machine,managedinstalls,munkiinfo,munkireport,network,security,warranty" \
    SITENAME="MunkiReport"

COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]
