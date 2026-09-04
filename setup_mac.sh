#!/bin/bash

set_default_shell_to_bash() {
  chsh -s /bin/bash
}

install_command_line_tools() {
  xcode-select --install
}

install_brew_packages() {
  if ! which brew 2>/dev/null >/dev/null; then
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
    watchman
    neovim
    font-jetbrains-mono-nerd-font
    ripgrep # Required for neovim telescope live_grep and grep_string
  )

  echo "Installing Homebrew packages"
  brew update && brew install "${packages[@]}"
}

install_usql() {
  echo "Installing usql"
  brew tap xo/xo
  brew install --with-odbc xo/xo/usql
}

install_usql() {
  echo "Installing psql, pg_dump, etc"
  brew install libpq
  # libpq provides some of the same utils as the full postgresql package, so brew installs
  # it "keg-only" by default, which means it isn't in the PATH. The following command will
  # symlink the executables to /usr/local/bin but these links will prevent you from
  # installing the full postgresql package in the future.
  brew link --force libpq
}

install_terraform() {
  echo "Installing Terraform"
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
}

install_rust() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
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
  gem install "${gems[@]}"
}

install_git_completion() {
  if [[ ! -e ~/.git-completion.bash ]]; then
    echo "Downloading git auto-completion script"
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
  fi
}

setup_terminal() {
  echo "Applying terminal settings"
  defaults write com.apple.Terminal AppleShowScrollBars -string WhenScrolling
  # Nerd Font: JetBrains Mono font, no ligatures, monospaced
  defaults write com.apple.Terminal "NSFont" -string "JetBrainsMonoNLNFM-Regular 16"
}

install_nvm() {
  echo "Installing nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
}

install_node() {
  echo "Installing node and npm"
  nvm install --lts
}

install_docker() {
  echo "Installing Docker"
  brew install --cask docker
}

install_uv() {
  echo "Installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
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

install_gitx() {
  # Git GUI
  echo "Installing Gitx"
  brew install --cask gitx
}

install_ghostty() {
  echo "Installing ghostty"
  brew install --cask ghostty
}

main() {
  set_default_shell_to_bash
  install_ghostty
  install_command_line_tools
  install_git_completion
  install_brew_packages
  install_usql
  install_psql
  install_terraform
  install_rust
  install_ruby
  install_gems
  setup_terminal
  install_nvm
  install_node
  install_docker
  install_uv
  install_python
  install_gitx
}

main
