#!/bin/bash

function _find_entity_helper {
  DATA=$1
  NUMBER_OF_LINES=$(echo "$DATA" | wc -l | xargs) # xargs for strip

  if [[ -z $DATA ]]; then
    echo "no entities found" >&2
    return 1
  fi
  if [[ $NUMBER_OF_LINES == 1 ]]; then
    echo "$DATA"
  else
    echo "found multiple entities:" >&2
    echo "$DATA" >&2
    return 1
  fi
}


function find_entity {
  INPUT=$(</dev/stdin)
  DATA=$INPUT

  ARG=$1
  shift
  for NEXT_ARG in "$@"; do
    DATA=$(echo "$DATA" | grep -E "$ARG")
    ARG=$NEXT_ARG
  done

  DATA_FALLBACK=$(echo "$DATA" | grep -E "$ARG"'$')
  DATA=$(echo "$DATA" | grep -E "$ARG")

  if [[ ! -z "$DATA_FALLBACK" ]]; then
    _find_entity_helper "$DATA_FALLBACK" || return 1
    return 0
  fi
  _find_entity_helper "$DATA" || return 1
}


contains() {
  local e match="$1"
  shift
  for e; do [[ $e == "$match" ]] && return 0; done
  return 1
}


is_function() {
  if [[ $(type -t "${1?ensure_is_a_function: provide a command}") == "function" ]]; then
    return 0
  else
    return 1
  fi
}


function xargs2 {
  if is_function "$1"; then
    export -f "${1?}" # so subprocess bash can see it
  else
    echo "xargs2: use xargs" >&2
    return 1
  fi
  ARGS=$(printf "%q " "$@") # escape
  cat </dev/stdin | xargs bash -c "$ARGS \$@" _
}


function safe_base64() {
  # Implements URL-safe base64 of stdin, stripping trailing = chars.
  # Writes result to stdout.
  # TODO: this gives the following errors on Mac:
  #   base64: invalid option -- w
  #   tr: illegal option -- -
  local url_safe
  url_safe="$(base64 -w 0 - | tr '/+' '_-')"
  echo -n "${url_safe%%=*}"  # Strip trailing = chars
}
