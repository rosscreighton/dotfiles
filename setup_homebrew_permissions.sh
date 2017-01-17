#!/bin/bash

function main() {
  local brew_dir=/usr/local

  echo "setting permissions on subdirectories of $brew_dir"
  sudo find $brew_dir -type d -exec chmod g+ws {} \;
  echo "setting permissions on subfiles of $brew_dir"
  sudo find $brew_dir -type f -exec chmod g+w {} \;
  echo "changing group of $brew_dir recursively"
  sudo chgrp -R dev $brew_dir
}

main
