#!/bin/bash

function find_entity {
  #  param1
  INPUT=$(</dev/stdin)
  DATA=$(echo "$INPUT" | grep -E "$1")
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

contains() {
  local e match="$1"
  shift
  for e; do [[ $e == "$match" ]] && return 0; done
  return 1
}
export -f contains

function if_gt_then {
  STDIN=$(cat -)
  if (($STDIN > $1)); then
    echo more
  else
    echo less
  fi
}
