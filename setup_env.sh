#!/bin/bash

setup_symlinks() {
  local dir=~/dotfiles
  local olddir=~/dotfiles_old/$(date +"%m_%d_%Y")
  local files=(
    .gitconfig
    .gitignore
    .bashrc
    .bash_colors
    .profile
    .tmux.conf
    .vimrc
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
