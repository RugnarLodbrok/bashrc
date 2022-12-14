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
