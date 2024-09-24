#!/bin/sh

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

"$script_dir"/setup.sh &

# Set --proxy-headers forwarded so that Keycloak knows it is behind a proxy
exec /opt/keycloak/bin/kc.sh start-dev --proxy-headers forwarded
