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

function clickhouse-client-parse-string()
{
  url=$1
  if [[ $url =~ clickhouse://([^:]+):([^@]+)@([^:]+):([0-9]+)/(.+) ]]; then
      user="${BASH_REMATCH[1]}"
      password="${BASH_REMATCH[2]}"
      host="${BASH_REMATCH[3]}"
      port="${BASH_REMATCH[4]}"
      db_name="${BASH_REMATCH[5]}"

      echo clickhouse-client --host="${host}" --port=${port} --user=${user} --password=${password} --database=${db_name}

  else
      echo "The URL did not match the expected format." >&2
      return 1
  fi
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

function totp-adfs() {
    OTP=$(oathtool --totp -b "$ADFS_TOTP_SECRET")
    echo -n "${OTP}" | tee >(pbcopy)
    echo ''
}
function totp-adfs2() {
    OTP=$(oathtool --totp -b "$ADFS_TOTP_SECRET2")
    echo -n "${OTP}" | tee >(pbcopy)
    echo ''
}

function tvpn () {
  BIN=/opt/cisco/anyconnect/bin/vpn
  HOST=gw-vpn.tcsbank.ru
  echo -e "$VPN_USERNAME\n$(totp)" | $BIN -s connect $HOST
}

function tvpn2 () {
  BIN=/opt/cisco/anyconnect/bin/vpn
  HOST=vb.tcsbank.ru
  echo -e "$VPN_USERNAME\n$(totp)" | $BIN -s connect $HOST
}

function tvpn-disconnect () {
  BIN=/opt/cisco/anyconnect/bin/vpn
  $BIN -s disconnect
}
