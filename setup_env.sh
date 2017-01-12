#!/bin/bash

DIR=~/dotfiles
OLDDIR=~/dotfiles_old
FILES=".gitconfig"

mkdir -p $OLDDIR

for FILE in $FILES; do
  mv ~/.$FILE $OLDDIR/
  ln -s $DIR/$FILE ~/$FILE
done
