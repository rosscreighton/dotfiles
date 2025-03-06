#!/bin/bash

setup_dotfile_symlinks() {
  local dir=~/dotfiles
  local olddir=~/dotfiles_old/$(date +"%m_%d_%Y")
  local files=(
    .eslintrc
    .gitconfig
    .gitignore
    .bashrc
    .bash_colors
    .profile
    .tmux.conf
  )

  mkdir -p $olddir

  for file in ${files[*]}; do
    mv ~/$file $olddir/$file
    ln -s $dir/$file ~/$file
  done
}

setup_nvim_config_symlinks() {
  # Create the config dir
  mkdir -p ~/.config/
  pushd ~/.config/
    mkdir -p nvim
  popd

  local nvimConfigDir=~/.config/nvim/
  local nvimDotfilesDir=~/dotfiles/nvim

  # Create a dir to house the old config files that may have already
  # existed in the config dir
  local oldDir=~/dotfiles_old/$(date +"%m_%d_%Y")/nvim
  mkdir -p $oldDir

  # For each nvim config file
  for fileWithPath in "$nvimDotfilesDir"/*; do
    # Separate the file name from the full path
    fileName=$(basename "$fileWithPath")
    # Archive the existing config file into the archive dir
    mv $nvimConfigDir/$fileName $oldDir/$fileName
    # Link the config file in the git-tracked dotfiles dir to the
    # nvim config dir so that nvim can find it.
    ln -s $fileWithPath $nvimConfigDir/$fileName
  done
}

main() {
  . .profile

  setup_dotfile_symlinks
  setup_nvim_config_symlinks
}

main
