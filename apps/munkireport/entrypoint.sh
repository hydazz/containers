#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${1-}" == apache2* ]]; then
    cp -r /usr/src/munkireport/. /var/www/html/

    mkdir -p /var/www/html/local/{certs,dashboards,module_configs,modules,users,views}

    # If a composer.local.json overlay exists, update to resolve extra packages into the lock file
    if [[ -f /var/www/html/composer.local.json ]]; then
        composer update --no-dev --no-interaction --working-dir=/var/www/html
    else
        composer install --no-dev --no-interaction --working-dir=/var/www/html
    fi

    # Probably dont need migrations to run in init, Admin>Upgrade Database does the job...
    #echo >&2 "running migrations..."
    #(cd /var/www/html && php please migrate)
fi

exec "$@"
