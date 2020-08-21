#!/usr/bin/with-contenv sh
set -eu
echo "${CURVEDNS_PRIVATE_KEY}" > /etc/services.d/curvedns/env/CURVEDNS_PRIVATE_KEY
echo "${VAULT_TOKEN}" > /etc/services.d/vault-fetch/env/VAULT_TOKEN
