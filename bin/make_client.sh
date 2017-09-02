#!/usr/bin/env bash

function main {
  local shome="$(cd -P -- "${BASH_SOURCE%/*}/.." && pwd -P)"
  source "$shome/script/profile"
  source "$shome/config/openvpn/vars"


  local nm_server="$1"; shift
  local nm_client="$1-$(date +%s-%Y%m%d)"; shift

  export KEY_NAME="$nm_server"
  export KEY_DIR="$shome/keys/$nm_server"

  local BASE_CONFIG="$shome/config/openvpn/client.conf"
  local OUTPUT_DIR="$KEY_DIR/files"
  mkdir -p "$OUTPUT_DIR"

  build-key --batch "$nm_client"
  { cat "${BASE_CONFIG}"
    echo -e '<ca>';       cat "${KEY_DIR}/ca.crt";   echo -e '</ca>'
    echo -e '<cert>';     cat "${KEY_DIR}/${nm_client}.crt"; echo -e '</cert>'
    echo -e '<key>';      cat "${KEY_DIR}/${nm_client}.key"; echo -e '</key>'
    echo -e '<tls-auth>'; cat "${KEY_DIR}/ta.key";   echo -e '</tls-auth>'
  } > "${OUTPUT_DIR}/${nm_client}.ovpn"
}

main "$@"
