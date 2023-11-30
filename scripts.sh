#!/bin/bash

function ci() {
  if [ -z "${1}" ]; then
    message="WIP"
  else
    message="$*"
  fi

  FLAG_FILE='.alias-ci-ignore-branch'
  if [[ -f "$FLAG_FILE" ]]; then
      git ci -m "${message}"
  else
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    ticket_number=$(echo $current_branch | grep -oE 'TMSG-[0-9]+')
    if [ -n "$ticket_number" ]; then
      git ci -m "${ticket_number} ${message}"
    else
      echo >&2 "branch not found"
      return 1
    fi
  fi
}
