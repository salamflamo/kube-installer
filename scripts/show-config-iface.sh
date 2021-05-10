#!/bin/sh -x
[[ -z "${HOSTNAME}" ]] && echo "[ERROR] Provide hostname as first argument" && exit 123
[[ -z "${IP_ADDRESS}" ]] && echo "[ERROR] Provide static IP as second argument" && exit 123
[[ -z "${MAC_ADDRESS}" ]] && echo "[ERROR] Provide MAC address as the third argument" && exit 123

