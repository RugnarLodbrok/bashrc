#!/bin/bash
echo ~HELLO ALIASES~

alias ll="ls -la"
alias br='git br | grep \*'
alias glg='git log --graph --oneline --all'
alias python='python3'
alias pip='python3 -m pip'
alias colima_start='sudo echo starting colima &&
                    colima start --cpu 6 --memory 8 --disk 200 --mount $HOME:w &&
                    sudo ln -s $HOME/.colima/docker.sock /var/run/docker.sock'

alias drun='docker-compose run --service-ports'

function dexec {
  PS=$(docker ps)
  PS=$(echo "$PS" | grep -E "$1")
  NUMBER_OF_LINES=$(echo "$PS" | wc -l)
  if [ $NUMBER_OF_LINES = "1" ]; then
    C_ID=$(echo "$PS" | sed -E 's/^([0-9a-f]+)(.*)/\1/')
    docker exec -it "$C_ID" bash
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
