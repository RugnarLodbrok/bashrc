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

# todo move docker stuff to a separate file
alias drun='docker-compose run --service-ports'
alias ddown='docker-compose down'
alias dup='docker-compose up'
alias drop_first_line='tail -n +2'

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
