#!/bin/sh
# This script sets up keycloak by creating the applications realm if it does not already exist

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

# Wait for keycloak to start
"$script_dir"/wait-for-it.sh keycloak:8443 -t 60

export PATH=$PATH:/opt/keycloak/bin/

echo '>>> Logging into Keycloak'
kcadm.sh config credentials --server http://localhost:8080 --realm master --user admin --password password

# This won't create another realm if one with this name exists
echo '>>> Creating applications realm'
kcadm.sh get realms/applications || kcadm.sh create realms -s realm=applications -s displayName=Applications -s enabled=true

# This won't create another user if a user with this username already exists
echo '>>> Creating user with username=user and password=password'
kcadm.sh create users -r applications -f - <<EOF
{
  "username": "user",
  "email": "user@email.com",
  "firstName": "John",
  "lastName": "Doe",
  "enabled": true,
  "emailVerified": true,
  "credentials": [{
    "type": "password",
    "value": "password",
    "temporary": false
  }]
}
EOF
