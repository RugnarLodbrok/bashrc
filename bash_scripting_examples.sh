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
  local STDIN=$(cat -)
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
      local literal=$(printf "%q" "$IFS_")
      echo "iteration with IFS=<$literal>:"
      for x in $data; do
        echo $"- $x"
      done
    done
}

function example-act() {
    cat <<< $'123'  # value to pipe
    cat <(echo 1 2 3)  # stream to pipe
}

function echo-w-style() {
    #  example: `echo-w-style '\e[31m' hello` will write text in red
    local style_reset=$'\e[0m'
    local style=$(printf $1)
    shift
    echo "$style$@$style_reset"
}

function example-text-styles() {
  #- `\e[A`: Move cursor up one line
  #- `\e[B`: Move cursor down one line
  #- `\e[C`: Move cursor right one character
  #- `\e[D`: Move cursor left one character

  echo-w-style '\e[0m' default  # reset all attributes (color, bold, underline, etc.)
  echo-w-style '\e[1m' bold
  echo-w-style '\e[2m' dim
  echo-w-style '\e[3m' itelic
  echo-w-style '\e[4m' underline
  echo-w-style '\e[5m' blink
  echo-w-style '\e[7m' reverse
  echo-w-style '\e[8m' hidden

  local style

  for i in {-1..7}; do
    for j in {-1..7}; do
      local style_num
      if [[ $i -eq -1 ]]; then
        if [[ $j -eq -1 ]]; then
          style='\e[0m'
        else
          style='\e['"4$j"'m'
        fi
      else
        if [[ $j -eq -1 ]]; then
          style='\e['"3$i"'m'
        else
          style='\e['"3$i;4$j"'m'
        fi
      fi
      echo -n $(echo-w-style "$style" $style) $'\t '
    done
    echo ''
  done
}
