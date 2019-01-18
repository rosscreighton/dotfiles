### TERMINAL PREFS
#------------------------------------------------------------

export HISTCONTROL=ignoreboth:erasedups
export CLICOLOR=1
export TERM=xterm-256color
export EDITOR='vim'


## ALIASES
#------------------------------------------------------------

alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"

alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'

alias gitx="open -a gitx ./"
alias chrome="open -a 'Google Chrome'"
alias brave="open -a 'Brave Browser'"
alias finder="open -a 'Finder'"
alias dkr-stop='docker stop $(docker ps -aq)'
alias dkr-rm='docker rm $(docker ps -aq)'
alias dkr-rmi='docker rmi $(docker images -q)'

alias gush="cd ~/projects/gush/gush"
alias gush-start="gush && tmuxinator local"
alias gush-stop="tmux kill-session -t gush"

alias dots="cd ~/dotfiles/"

# clean branches local
alias git-cbl="git co master && git branch --merged | grep -v '\*\|master\|develop' | xargs -n 1 git branch -d"
# clean branches remote
alias git-cbr="git co master && git branch -r --merged | grep -v '\*\|master\|develop' | sed 's/origin\///' | xargs -n 1 git push --delete origin"



### PERMISSIONS
#------------------------------------------------------------

  # why do we change the default umask?
  #
  # the goal is to have multiple accounts on a dev machine,
  # one for personal work, one for company work. we also want
  # to be able to use homebrew to manage packages. homebrew
  # installs packages at a system level, and all user accounts
  # share these packages. the permissions on the homebrew
  # install directory are set based on the user installing the
  # package, so we get permission denied errors when one user
  # installs a package and another attempts to uninstall or
  # upgrade it. in order to use homebrew in this way, one must
  # continuously switch the owner of the homebrew dir between
  # users. the way we avoid this headache is to create a third
  # entity, a group, add each user to it, and make this group the
  # owner of the homebrew dir. see ./setup_homebrew_permissions
  # for details. groups cannot have write permissions by default,
  # so in order for ./setup_homebrew_permissions.sh to work, we
  # must change the user's default umask to 002.
umask 002


### SET UP PYENV
#------------------------------------------------------------
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


### SOURCING
#------------------------------------------------------------

. ~/.bash_colors

# gets virtualenvwrapper working in vagrant box
if [[ -e $(which virtualenvwrapper.sh) ]]; then
  . $(which virtualenvwrapper.sh)
fi

# enable git tab completion
if [[ -e ~/.git-completion.bash ]]; then
  . ~/.git-completion.bash
fi

# set up nvm - disabled for now
#export NVM_DIR="$HOME/.nvm"

#if which brew &> /dev/null; then
  #. $(brew --prefix nvm)/nvm.sh
#fi


### CUSTOM COMMAND PROMPT
#------------------------------------------------------------

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1]/"
}

function parse_hg_branch {
  hg branch 2> /dev/null | sed -e "s/\(.*\)/[\1]/"
}

function parse_jobs_count {
  jobs | wc -l | tr -d " "
}

function parse_virtualenv {
  VENV=""

  if [[ $VIRTUAL_ENV != "" ]]; then
    VENV+="<${VIRTUAL_ENV##*/}>"
  fi

  echo $VENV
}

function __prompt_command {
  local EXIT="$?" # must do this first
  PS1="\[${BPurple}\]\u\[${Color_Off}\]@"

  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    PS1+="\[${BRed}\]\h "
  else
    PS1+="\[${BGreen}\]\h "
  fi

  PS1+="\[${BYellow}\]\w \[${Cyan}\]$(parse_git_branch)$(parse_hg_branch)\[${Color_Off}\] "

  if [ "$(parse_virtualenv)" != "" ]; then
    PS1+="\[${BBlue}\]$(parse_virtualenv)\[${Color_Off}\] "
  fi

  if [ "$(parse_jobs_count)" != "0" ]; then
    PS1+="\[${White}\](\j)\[${Color_Off}\] "
  fi

  # Is it bad?
  if [ $EXIT != 0 ]; then
    PS1+="\[${Red}\]→ $EXIT\[${Color_Off}\] "      # Add red if exit code non 0
  fi

  PS1+="\n$ "
}

export PROMPT_COMMAND=__prompt_command
