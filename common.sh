#!/bin/bash

function find_entity_helper {
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
  DATA=$(echo "$INPUT" | grep -E "$1")
  DATA_FALLBACK=$(echo "$INPUT" | grep -E "$1"'$')
  NUMBER_OF_LINES=$(echo "$DATA" | wc -l | xargs) # xargs for strip
  NUMBER_OF_LINES_FALLBACK=$(echo "$DATA_FALLBACK" | wc -l | xargs)
  if [[ -z $DATA ]]; then
    echo "no entities found" >&2
    return 1
  fi
  if [[ $NUMBER_OF_LINES == 1 ]]; then
    echo "$DATA"
  else
    if [[ ! -z $DATA_FALLBACK ]]; then
      if [[ $NUMBER_OF_LINES_FALLBACK == 1 ]]; then
        echo "$DATA_FALLBACK"
        return 0
      fi
      DATA=$DATA_FALLBACK
    fi
    echo "found multiple entities:" >&2
    echo "$DATA" >&2
    return 1
  fi
}

contains() {
  local e match="$1"
  shift
  for e; do [[ $e == "$match" ]] && return 0; done
  return 1
}

function if_gt_then {
  STDIN=$(cat -)
  if (($STDIN > $1)); then
    echo more
  else
    echo less
  fi
}

enumerate_args() {
  local index=1
  for arg in "$@"; do
    echo "Argument $index: $arg"
    ((index++))
  done
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

function my_echo() {
    echo "$@"
}
