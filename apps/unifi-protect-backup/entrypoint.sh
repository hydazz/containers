#!/usr/bin/env bash

CONFIG_FILE="/config/rclone.conf"

# Ensure the config file exists, copy default if missing
if [[ ! -f "${CONFIG_FILE}" ]]; then
    mkdir -p "${CONFIG_FILE%/*}"
    cp /defaults/rclone.conf "${CONFIG_FILE}"
fi

exec /usr/local/bin/unifi-protect-backup "$@"