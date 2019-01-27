#!/bin/sh -eu
ln -s /run/secrets/dnscurve-private-key /service/curvedns/env/CURVEDNS_PRIVATE_KEY
exec runsvdir -P /service
