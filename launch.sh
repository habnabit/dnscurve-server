#!/bin/sh -eu
echo "${CURVEDNS_PRIVATE_KEY}" > /service/curvedns/env/CURVEDNS_PRIVATE_KEY
unset CURVEDNS_PRIVATE_KEY
exec runsvdir -P /service
