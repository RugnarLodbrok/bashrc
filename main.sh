#!/bin/bash
echo ~HELLO BASH_MAIN~
PREFIX="$HOME/.bash"
pushd $PREFIX

for FILE in *.sh; do
  [ "$FILE" != "main.sh" ] || continue
  echo include $FILE
  F="$PREFIX/$FILE"
  . "$FILE"
done

popd
