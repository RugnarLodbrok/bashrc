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

function docker-login-artifactory() {
  dp auth login
  dp auth configure-docker
}

function dexec {
  PS=$(docker ps)
  PS=$(echo "$PS" | grep -E "$1")
  NUMBER_OF_LINES=$(echo "$PS" | wc -l)
  if [ $NUMBER_OF_LINES = "1" ]; then
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


function if_gt_then  {
  STDIN=$(cat -)
  if (( $STDIN > $1 )); then
    echo more
  else
    echo less
  fi
}
