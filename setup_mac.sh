#!/bin/bash

set_default_shell_to_bash() {
  chsh -s /bin/bash
}

install_command_line_tools() {
  xcode-select --install
}

install_brew_packages() {
  if ! which brew 2> /dev/null > /dev/null; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    hash -r && brew update
  fi

  packages=(
    cmake
    ctags
    pyenv
    pyenv-virtualenv
    reattach-to-user-namespace
    rbenv
    ruby-build
    tmux
    vim
    watchman
  )

  echo "Installing Homebrew packages"
  brew update && brew install ${packages[@]}
}

install_ruby() {
  rbenv install 3.3.0
  rbenv global 3.3.0
}

install_gems() {
  gems=(
    tmuxinator
    bundler
  )

  echo "Installing gems"
  gem install ${gems}
}

install_git_completion() {
  if [[ ! -e ~/.git-completion.bash ]]; then
    echo "Downloading git auto-completion script"
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
  fi
}

install_vim_plug() {
  if [[ ! -e ~/.vim/autoload/plug.vim ]]; then
    echo "Installing vim plug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
}

setup_vim_undo() {
  echo "Setting up vim undo"
  mkdir -p ~/.vim/undo
}

setup_terminal() {
  echo "Applying terminal settings"
  defaults write com.apple.Terminal AppleShowScrollBars -string WhenScrolling
}

install_nvm() {
  echo "Installing nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
}

install_nvm() {
  echo "Installing node and npm"
  nvm install --lts
}

install_docker() {
  echo "Installing Docker"
  brew install --cask docker
}

install_python() {
  echo "Installing python stuff"
  pyenv install 3.12.1
  pyenv global 3.12.1

  # Required for YouCompleteMe vim plugin
  pip install setuptools
  # Required for Black fixer in ALE
  pip install black
}

install_vim_plugins() {
  echo "Installing vim plugins"
  vim +'PlugInstall --sync' +qa

  echo "Running YouCompleteMe install script"
  pushd ~/.vim/plugged/YouCompleteMe
  echo $(python --version)
  echo "^^ Make sure this is the python version you expect. It should be the global version installed by pyenv."
  read -p "Press enter to continue."
  python ./install.py --ts-completer
  popd
}

install_gitx() {
  # Git GUI
  echo "Installing Gitx"
  brew install --cask gitx
}

main() {
  set_default_shell_to_bash
  install_command_line_tools
  install_git_completion
  install_brew_packages
  install_ruby
  install_gems
  install_vim_plug
  setup_vim_undo
  setup_terminal
  install_nvm
  install_docker
  install_python
  install_vim_plugins
  install_gitx
}

main
