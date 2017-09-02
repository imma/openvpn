#!/usr/bin/env bash

function main {
  local shome="$(cd -P -- "${BASH_SOURCE%/*}/.." && pwd -P)"
  source "$shome/script/profile"
  source "$shome/config/openvpn/vars"

  local nm_server="$1"; shift

  export KEY_NAME="$nm_server"
  export KEY_DIR="$shome/keys/$nm_server"
  mkdir -p "$KEY_DIR"

  clean-all
  build-ca --batch
  build-key-server --batch "$nm_server"
  build-dh --batch
  openvpn --genkey --secret "$KEY_DIR/ta.key"
}

main "$@"
