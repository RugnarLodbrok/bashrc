#!/bin/bash
echo ~HELLO BASH_MAIN~

declare -a files=(
  "settings.sh"
  "aliases.sh"
  "path.sh"
  "keys.sh"
  "git-completion.sh"
)

for FILE in "${files[@]}"; do
  if [ -f "$FILE" ]; then
    . ~/.bash/${FILE}
  fi
done
