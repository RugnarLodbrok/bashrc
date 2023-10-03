#!/bin/bash
echo ~HELLO BASH_MAIN~

declare -a files=(
  "keys.sh"
  "common.sh"
  "settings.sh"
  "aliases.sh"
  "scripts.sh"
  "path.sh"
  "docker.sh"
  "kube.sh"
  "git-completion.sh"
)

for FILE in "${files[@]}"; do
  if [ -f "$HOME/.bash/$FILE" ]; then
    . ~/.bash/${FILE}
  fi
done
