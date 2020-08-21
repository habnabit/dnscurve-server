#!/bin/sh -eu
echo "${CURVEDNS_PRIVATE_KEY}" > /service/curvedns/env/CURVEDNS_PRIVATE_KEY
echo "${VAULT_TOKEN}" > /service/vault-fetch/env/VAULT_TOKEN
unset CURVEDNS_PRIVATE_KEY VAULT_TOKEN
exec runsvdir -P /service
