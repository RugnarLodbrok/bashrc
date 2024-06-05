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

function totp() {
#  https://wiki.tcsbank.ru/pages/viewpage.action?pageId=2904580153
#  https://wiki.tcsbank.ru/pages/viewpage.action?pageId=2171876564
# для впн:
#  - https://access.tinkoff.ru/accesses/tokens
#  - в разделе TOTP создать новый токен или сбросить пин
#  - <пин> и <токен> придут в смс
#  - <токен> нужен для генерации <otp>
#  - <pin> является статическим паролем
#  - Для входа в VPN в поле пароля ввести слитно <pin><otp>
# для ADFS (wiki и остальное):
#  - time -> /infrabot -> Восстановить ADFS TOTP
#  - получить <токен>
#  - <токен> нужен для генерации <otp>
#  - Для входа в через ADFS использовать пароль от учетки
#  - вместо смс можно использовать <otp>

  OTP=$(oathtool --totp -b "$VPN_TOTP_SECRET")
  echo -n "${VPN_TOTP_PIN}${OTP}" | tee >(pbcopy)
  echo ''
}

function totp-wiki() {
    OTP=$(oathtool --totp -b "$ADFS_TOTP_SECRET")
    echo -n "${OTP}" | tee >(pbcopy)
    echo ''
}
# vb.tcsbank.ru запасной впн
