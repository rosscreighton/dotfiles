#!/bin/bash

setup_symlinks() {
  local dir=~/dotfiles
  local olddir=~/dotfiles_old
  local files=(
    .gitconfig
    .bashrc
    .profile
  )

  mkdir -p $olddir

  for file in ${files[*]}; do
    mv ~/$file $olddir/
    ln -s $dir/$file ~/$file
  done
}

main() {
  . .profile

  setup_symlinks
}

main
