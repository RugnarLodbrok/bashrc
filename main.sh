#!/bin/bash
echo ~HELLO BASH_MAIN~

echo DEFAULT PATH: ${PATH}
. ~/.bash/settings.sh
. ~/.bash/aliases.sh
. ~/.bash/path.sh

#export GIT_COMPLETION_CHECKOUT_NO_GUESS=1
. ~/.bash/git-completion.sh
