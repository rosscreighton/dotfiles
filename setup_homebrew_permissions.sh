#!/bin/bash

function main() {
  local brew_dir=/usr/local

  echo "setting group permissions on subdirectories of $brew_dir"
  # sets group permissions for dir and also sets group ID bit.
  # when another user creates a file or directory under $brew_dir
  # the new file or directory will have its group set as the
  # group of the owner of $brew_dir, instead of the group of the
  # user who creates it. this is the special sauce that enables
  # multiple accounts to share a homebrew install directory.
  sudo find $brew_dir -type d -exec chmod g+ws {} \;

  echo "setting group permissions on subfiles of $brew_dir"
  sudo find $brew_dir -type f -exec chmod g+w {} \;

  echo "changing group of $brew_dir recursively"
  sudo chgrp -R dev $brew_dir
}

main
