#!/bin/bash
echo ~HELLO BASH_MAIN~

echo DEFAULT PATH: ${PATH}
. ~/.bash/settings.sh
. ~/.bash/aliases.sh
. ~/.bash/path.sh

if [ -f ~/.git-completion.bash ]; then
  export GIT_COMPLETION_CHECKOUT_NO_GUESS="1"
  . ~/.git-completion.bash
fi
