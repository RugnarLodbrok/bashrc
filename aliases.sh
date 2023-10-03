#!/bin/bash
echo ~HELLO ALIASES~

alias ll="ls -la"
alias pp="ping 8.8.8.8"
alias br='git br | grep \*'
alias glg='git log --graph --oneline --all'
alias python39='/usr/bin/python3'
alias python='python3.11'
alias py='python'
alias py='
  if [[ -f ".venv/bin/activate" ]]; then
    source .venv/bin/activate;
  else
    if command -v deactivate >/dev/null 2>&1; then
      deactivate
    fi;
  fi && python'
alias pip='python -m pip'
alias colima_start='sudo echo starting colima &&
                    colima start --cpu 6 --memory 8 --disk 200 --mount $HOME:w &&
                    sudo ln -s $HOME/.colima/docker.sock /var/run/docker.sock'

alias drun='docker-compose run --service-ports'
alias ddown='docker-compose down'
alias dup='docker-compose up'
alias drop_first_line='tail -n +2'

alias dpauth='dp auth login g.usatenko'
alias kaqa='dp auth configure-kubeconfig --cluster-name ya-ruc1-dev1.dev --account-name g.usatenko@tinkoff.ru'
alias kaprod='dp auth configure-kubeconfig --cluster-name ds-prod2.prod --account-name g.usatenko@tinkoff.ru'
alias kaprod_m1='dp auth configure-kubeconfig --cluster-name m1-prod2.prod --account-name g.usatenko@tinkoff.ru'
alias k='kubectl'
alias kan='k config set-context --current --namespace'

alias va='source .venv/bin/activate'

#alias eval_env_file='eval $(grep -v '\''^#'\'' .env | grep -v -e '\''^$'\'' | sed -E "s/(.*)=(.*)/export \1='\''\2'\''/")'
function eval_env_file() {
  if [ -z "$1" ]; then
    FILE=.env
  else
    FILE="$1"
  fi
  eval $(grep -v '^#' $FILE | grep -v -e '^$' | sed -E "s/(.*)=(.*)/export \1='\2'/")
}

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
    return 1
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
