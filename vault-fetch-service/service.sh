#!/bin/sh -eu

_vault_fetch() {
    wget -q -O "$1" --header "X-Vault-Token: $VAULT_TOKEN" \
         http://vault.service.consul:8200/v1/kv/data/dnscurve/data
}
_version() {
    jq .data.metadata.version "$1"
}
_install() {
    echo 1>&2 "installing data version $(_version "$1")"
    jq -r '.data.data.cdb_base64' "$1" | base64 -d > data.cdb
    mv data.cdb /service/tinydns/root/
}
cd workdir
_vault_fetch current
_install current
current_version=$(_version current)
while sleep $((60 - $(date +%S))); do
    _vault_fetch tmp
    tmp_version=$(_version tmp)
    if [ "$current_version" -ne "$tmp_version" ]; then
        _install tmp
        mv tmp current
        current_version=$tmp_version
    fi
done
