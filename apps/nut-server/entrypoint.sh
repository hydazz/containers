#!/bin/sh
set -e

/usr/sbin/upsdrvctl start
exec /usr/sbin/upsd -D
