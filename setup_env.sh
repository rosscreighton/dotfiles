#!/bin/bash

dir=~/dotfiles
olddir=~/dotfiles_old
files=".gitconfig"

mkdir -p $olddir
cd $dir

for file in $files; do
  mv ~/.$file ~/dotfiles_old/
  ln -s $dir/$file ~/.$file
done
