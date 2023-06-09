#!/bin/bash

function ci() {
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  ticket_number=$(echo $current_branch | grep -oE 'TMSG-[0-9]+')
  if [ -n "$ticket_number" ]; then
    if [ -z "${1}" ]; then
      message="WIP"
    else
      message="$*"
    fi
    git ci -m "$ticket_number ${message}"
  else
    echo >&2 "branch not found"
    return 1
  fi
}
