#!/usr/bin/env bash

## check for .env file and generate app keys if missing
if [ -f /app/var/.env ]; then
    echo "external vars exist."
else
    echo "external vars don't exist."
    
    ## manually generate a key because key generate --force fails
    if [ -z "$APP_KEY" ]; then
        echo -e "Generating key."
        APP_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
        echo -e "Generated app key: $APP_KEY"
        echo -e "APP_KEY=$APP_KEY" > /app/var/.env
    else
        echo -e "APP_KEY exists in environment, using that."
        echo -e "APP_KEY=$APP_KEY" > /app/var/.env
    fi
fi

ln -sf /app/var/.env /app/

## make sure the db is set up
echo -e "Migrating and Seeding D.B"
php artisan migrate --seed --force || : # who cares

## start cronjobs for the queue
echo -e "Starting cron jobs."
crond -L /var/log/crond -l 5

echo -e "Starting process: $@"
exec "$@"
