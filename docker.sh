#!/bin/bash

alias drun='docker compose run --rm --service-ports'
alias ddown='docker compose down'
alias dup='docker compose up'

function filter_docker_ps_old {
  local PS=$(docker ps)
  PS=$(echo "$PS" | grep -E "$1")
  local NUMBER_OF_LINES=$(echo "$PS" | wc -l)
  if [ $NUMBER_OF_LINES = "1" ]; then
    C_ID=$(echo "$PS" | sed -E 's/^([0-9a-f]+)(.*)/\1/')
    echo $C_ID
  else
    echo "found multiple containers:" >&2
    echo "$PS" >&2
    exit 1
  fi
}

function find_docker_container {
  local LINE=$(docker ps | find_entity "$1") || return 1
  local C_ID=$(echo "$LINE" | sed -E 's/^([0-9a-f]+)(.*)/\1/')
  echo "$C_ID"
}

function dkill {
  local C_ID=$(find_docker_container "$1") || return 1
  if [[ -z $C_ID ]]; then
    return 1
  else
    docker stop -t 5 "$C_ID" || docker kill "$C_ID"
  fi
}

function dexec {
  local C_ID=$(find_docker_container "$1") || return 1
  docker exec -it "$C_ID" "${@:2}"
}

function dexec-it {
  local C_ID=$(find_docker_container "$1") || return 1
  docker exec -it "$C_ID" "${@:2}"
}

function docker-rm-all-containers {
  function do_containers_if_any() {
    local OPERATION=$1
    local VALID_OPERATIONS=("kill" "rm")
    echo "${VALID_OPERATIONS[@]}" | xargs2 contains "$OPERATION" || {
      echo bad option "$OPERATION"
      return 1
    }
    local C_IDS=$(</dev/stdin)
    if [[ -n $C_IDS ]]; then
      echo "$C_IDS" | xargs docker "$OPERATION"
    fi
  }

  docker ps -q | xargs | do_containers_if_any kill
  docker ps -aq | xargs | do_containers_if_any rm
}

function update_project_docker_image {
  local PREFIX="docker-hosted.artifactory.tcsbank.ru/tmsg"
  docker pull "$PREFIX/${1}-dev:latest" || return 1
  docker tag "$PREFIX/${1}-dev:latest" "${1}_dev:latest" || return 1
}

function docker-login-artifactory() {
  dp auth login
  dp auth configure-docker
}
