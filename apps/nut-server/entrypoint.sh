#!/usr/bin/env bash

# Copy default configs if they don't exist
for src in /defaults/*; do # meh, does the job
    dst_name=$(basename "${src}")
    if [[ ! -f "/etc/nut/${dst_name}" ]]; then
        cp "${src}" "/etc/nut/${dst_name}"
    fi
done

/usr/sbin/upsdrvctl -u root start
exec /usr/sbin/upsd -u root -D
