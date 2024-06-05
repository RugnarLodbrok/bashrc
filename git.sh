#!/bin/bash

alias br='git br | grep \*'
alias glg='git log --graph --oneline --all'
alias glg1='git log --graph --oneline'
alias pull='git stash && git pull && git stash pop'
alias pull_fork='git co master && git fetch upstream master && git rebase upstream/master'

function co() {
  if [[ -z $1 ]]; then
    echo "specify branch or commit" >/dev/stderr
    return 1
  fi
  git stash
  git co $1
  git stash pop
}

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
