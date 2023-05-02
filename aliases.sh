#!/bin/bash
echo ~HELLO ALIASES~

alias ll="ls -la"
alias pp="ping 8.8.8.8"
alias br='git br | grep \*'
alias glg='git log --graph --oneline --all'
alias python='python3'
alias pip='python3 -m pip'
alias colima_start='sudo echo starting colima &&
                    colima start --cpu 6 --memory 8 --disk 200 --mount $HOME:w &&
                    sudo ln -s $HOME/.colima/docker.sock /var/run/docker.sock'

alias drun='docker-compose run --service-ports'
alias ddown='docker-compose down'
alias dup='docker-compose up'
alias drop_first_line='tail -n +2'

function docker-login-artifactory() {
  dp auth login
  dp auth configure-docker
}

function filter_docker_ps {
  PS=$(docker ps)
  PS=$(echo "$PS" | grep -E "$1")
  NUMBER_OF_LINES=$(echo "$PS" | wc -l)
  if [ $NUMBER_OF_LINES = "1" ]; then
    C_ID=$(echo "$PS" | sed -E 's/^([0-9a-f]+)(.*)/\1/')
    echo $C_ID
  else
    echo "found multiple containers:" >&2
    echo "$PS" >&2
    exit 1
  fi
}

function dkill {
  C_ID=$(filter_docker_ps $1)
  if [[ "$C_ID" != "" ]]; then
    docker kill "$C_ID"
  else
    exit 1
  fi
}

function dexec {
  PS=$(docker ps)
  PS=$(echo "$PS" | grep -E "$1")
  NUMBER_OF_LINES=$(echo "$PS" | wc -l | xargs)
  if [ "$NUMBER_OF_LINES" = "1" ]; then
    C_ID=$(echo "$PS" | sed -E 's/^([0-9a-f]+)(.*)/\1/')
    docker exec -it "$C_ID" "${@:2}"
  else
    echo "found multiple containers:"
    echo "$PS"
    return 1
  fi
}

function dexec2 {
  PS=$(docker ps)
  PS=$(echo "$PS" | grep -E "$1")
  NUMBER_OF_LINES=$(echo "$PS" | wc -l)
  if [ $NUMBER_OF_LINES = "1" ]; then
    C_ID=$(echo "$PS" | sed -E 's/^([0-9a-f]+)(.*)/\1/')
    docker exec "$C_ID" "${@:2}"
  else
    echo "found multiple containers:"
    echo "$PS"
    return 1
  fi
}

function if_gt_then {
  STDIN=$(cat -)
  if (($STDIN > $1)); then
    echo more
  else
    echo less
  fi
}

function docker-rm-all-containers {
  set -e
  RUNNING_CIDS=$(docker ps -q)
  ALL_CIDS=$(docker ps -aq )
  if [ "$RUNNING_CIDS" ]; then
    docker stop $RUNNING_CIDS
  fi
  if [ "$ALL_CIDS" ]; then
    docker rm $ALL_CIDS
  fi
}

function update_project_docker_image {
  PREFIX="docker-hosted.artifactory.tcsbank.ru/tmsg"
  docker pull "$PREFIX/${1}-dev:latest" &&
    docker tag "$PREFIX/${1}-dev:latest" "${1}_dev:latest"
}
