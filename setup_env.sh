#!/bin/bash

setup_symlinks() {
  local dir=~/dotfiles
  local olddir=~/dotfiles_old/${date}
  local files=(
    .gitconfig
    .bashrc
    .bash_colors
    .profile
  )

  mkdir -p $olddir

  for file in ${files[*]}; do
    mv ~/$file $olddir/$file
    ln -s $dir/$file ~/$file
  done
}

main() {
  . .profile

  setup_symlinks
}

main
