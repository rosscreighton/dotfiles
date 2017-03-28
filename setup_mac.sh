#!/bin/bash

install_brew_packages() {
  if ! which brew 2> /dev/null > /dev/null; then
    echo "installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    hash -r && brew update
  fi

  packages=(
    ctags
    flake8
    nvm
    pyenv
    pyenv-virtualenv
    reattach-to-user-namespace
    tmux
    vim
  )

  echo "installing homebrew packages"
  brew update && brew install -y ${packages[@]}
}

install_gems() {
  gems=(
    tmuxinator
  )

  echo "installing gems"
  gem install ${gems}
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

setup_terminal() {
  defaults write com.apple.Terminal AppleShowScrollBars -string WhenScrolling
}

main() {
  install_git_completion
  install_brew_packages
  install_gems
  install_vim_plug
  setup_terminal
}

main
