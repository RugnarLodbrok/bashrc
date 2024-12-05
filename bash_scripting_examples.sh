#!/bin/bash

function my_echo() {
    echo "$@"
}

function how-to-line-break() {
    echo -e "example1:\nbreak\n"
    echo example2$'\n'break$'\n'
    printf "example3:\nbreak\n\n"
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

function example-for-loop() {
    local data="a bc def"$'\n'"gh"
    echo data:$'\n'"$data"$'\n'

    # the first one is the default value
    local IFS_POSSIBILITIES=($' \t\n' $' ' '' $'\n')
    for IFS_ in "${IFS_POSSIBILITIES[@]}"; do
      IFS="$IFS_"
      literal=$(printf "%q" "$IFS_")
      echo "iteration with IFS=<$literal>:"
      for x in $data; do
        echo $"- $x"
      done
    done
}

function cat-examples() {
    cat <<< $'123'  # value to pipe
    cat <(echo 1 2 3)  # stream to pipe
}
