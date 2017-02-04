#!/bin/bash

install_brew_packages() {
  if ! which brew 2> /dev/null > /dev/null; then
    echo "installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    hash -r && brew update
  fi

  packages=(
    nvm
  )

  echo "installing homebrew packages"
  brew update && brew install -y ${packages[@]}
}

install_git_completion() {
  if [[ ! -e ~/.git-completion.bash ]]; then
    echo "downloading git auto-completion script"
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
  fi
}

install_vim_plug() {
  if [[ ! -e ~/.vim/autoload/plug.vim ]]; then
    echo "installing vim plug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
}

main() {
  install_git_completion
  install_brew_packages
  install_vim_plug
}

main
