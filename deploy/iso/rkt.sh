#!/usr/bin/env bash

set -e
set -x

rkt_version="1.11.0"
install_dir="."

curl -sSL https://coreos.com/dist/pubkeys/app-signing-pubkey.gpg | gpg2 --import -
key=$(gpg2 --with-colons --keyid-format LONG -k security@coreos.com | egrep ^pub | cut -d ':' -f5)

curl -fSL -O https://github.com/coreos/rkt/releases/download/v"${rkt_version}"/rkt-v"${rkt_version}".tar.gz
curl -fSL -O https://github.com/coreos/rkt/releases/download/v"${rkt_version}"/rkt-v"${rkt_version}".tar.gz.asc

gpg2 --trusted-key "${key}" --verify-files *.asc

tar xvzf rkt-v"${rkt_version}".tar.gz

for flavor in coreos; do
    install -Dm644 rkt-v${rkt_version}/stage1-${flavor}.aci "${install_dir}"/rkt/stage1-images/stage1-${flavor}.aci
done

install -Dm755 rkt-v${rkt_version}/rkt rkt/bin/rkt
