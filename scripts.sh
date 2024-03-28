#!/bin/bash

function kill_nsurlsessiond() {
  while true; do
    killall nsurlsessiond 2>/dev/null &&
      echo "nsurlsessiond killed at $(date)" ||
      (
        echo -n "not found at $(date)" &&
          echo -ne "\r" &&
          sleep 20
      )
  done
}

#  https://wiki.tcsbank.ru/pages/viewpage.action?pageId=2904580153
function totp() {
  USERNAME=$(whoami)

  # UI app: Keychain Access
  STATIC_PIN=$(security find-generic-password -a "$USERNAME" -s "Tinkoff VPN OTP static pin" -w)
  SECRET=$(security find-generic-password -a "$USERNAME" -s "Tinkoff VPN OTP secret" -w)

  OTP=$(oathtool --totp -b "$SECRET")

  # Copy the combined password to clipboard
  echo -n "${STATIC_PIN}${OTP}" | tee >(pbcopy)
  echo ''
}

function totp-wiki() {
    SECRET=$ADFS_TOTP_SECRET
    OTP=$(oathtool --totp -b "$SECRET")
    echo -n "${OTP}" | tee >(pbcopy)
    echo ''
}
