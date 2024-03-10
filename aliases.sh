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
alias check_disk='stat /Users/g.usatenko/Library/Caches/JetBrains/PyCharm2022.3/python_packages/packages_v2.json'

alias drop_first_line='tail -n +2'

alias va='source .venv/bin/activate'
alias da='deactivate'

#alias eval_env_file='eval $(grep -v '\''^#'\'' .env | grep -v -e '\''^$'\'' | sed -E "s/(.*)=(.*)/export \1='\''\2'\''/")'
function eval_env_file() {
  if [ -z "$1" ]; then
    FILE=.env
  else
    FILE="$1"
  fi
  eval $(grep -v '^#' $FILE | grep -v -e '^$' | sed -E "s/(.*)=(.*)/export \1='\2'/")
}

function cwd-pythonpath {
  # Get the current working directory
  current_dir=$(pwd)

  if [[ -z "${PYTHONPATH}" ]]; then
    export PYTHONPATH="${current_dir}"
  else
    export PYTHONPATH="${PYTHONPATH}:${current_dir}"
  fi
  echo "Current working directory added to PYTHONPATH: ${current_dir}"
}

function ae() {
  poetry install --all-extras || return 1
  va || return 1
  stat .env.local >/dev/null || return 1
  cp -f .env.example .env || return 1
  printf '\n' >>.env || return 1
  cat .env.local >>.env || return 1
  eval_env_file .env.local || return 1
}

function pip-uninstall-all {
  packages=$(pip list 2>/dev/null | drop_first_line | drop_first_line | grep -v pip | grep -v setuptools | sed -E 's/([^ '$'\t'']+)[ \t]+.*/\1/')
  echo "$packages" | xargs echo pip uninstall -y
}
