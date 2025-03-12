#!/bin/bash
echo ~HELLO PS1~

# get current branch in git repo
function parse_git_branch() {
 local BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
 if [ ! "${BRANCH}" == "" ]
 then
  local STAT=`parse_git_dirty`
  echo "[${BRANCH}${STAT}]"
 else
  echo ""
 fi
}

# get current status of git repo
function parse_git_dirty {
 local status=`git status 2>&1 | tee`
 local dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
 local untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
 local ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
 local newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
 local renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
 local deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
 local bits=''
 if [ "${renamed}" == "0" ]; then
  bits=">${bits}"
 fi
 if [ "${ahead}" == "0" ]; then
  bits="*${bits}"
 fi
 if [ "${newfile}" == "0" ]; then
  bits="+${bits}"
 fi
 if [ "${untracked}" == "0" ]; then
  bits="?${bits}"
 fi
 if [ "${deleted}" == "0" ]; then
  bits="x${bits}"
 fi
 if [ "${dirty}" == "0" ]; then
  bits="!${bits}"
 fi
 if [ ! "${bits}" == "" ]; then
  echo " ${bits}"
 else
  echo ""
 fi
}

#export PS1="\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[33m\]\w\[\e[m\]\[\e[36m\]\`parse_git_branch\`\[\e[m\]$ "
export PS1="\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[33m\]\w\[\e[m\]$ "
