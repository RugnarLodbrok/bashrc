#!/bin/bash

function my_echo() {
    echo "$@"
}

function example_iterate_arguments() {
    while [[ $# -gt 0 ]]; do
        echo "Argument: $1"
        shift
    done
}

function example_if_gt_then {
  STDIN=$(cat -)
  if (($STDIN > $1)); then
    echo more
  else
    echo less
  fi
}

function example_enumerate_args() {
  local index=1
  shift
  for arg in "$@"; do
    echo "Argument $index: $arg"
    ((index++))
  done
}
