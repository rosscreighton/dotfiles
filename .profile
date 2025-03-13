### TERMINAL PREFS
#------------------------------------------------------------

export HISTCONTROL=ignoreboth:erasedups
export CLICOLOR=1
export TERM=xterm-256color
export EDITOR='vim'
export AWS_DEFAULT_REGION=us-east-1


### HOMEBREW SETUP
#------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"


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

alias td="cd ~/todos/"
alias tdup="td && tmuxinator local"
alias tddown="tmux kill-session -t todos"

alias gush="cd ~/projects/gush/gush"
alias gush-start="gush && tmuxinator local"
alias gush-stop="tmux kill-session -t gush"

alias portal="cd ~/projects/fws/portal"
alias portal-start="portal && tmuxinator local"
alias portal-stop="tmux kill-session -t portal"

alias helix="cd ~/projects/fws/helix2"
alias helix-start="helix && tmuxinator local"
alias helix-stop="tmux kill-session -t helix"

alias fwswm="cd ~/projects/fws/fws-windmill"
alias fwswm-start="fwswm && tmuxinator local"
alias fwswm-stop="tmux kill-session -t fwswm"

alias ft="cd ~/projects/fantasy_toolbox"
alias ft-start="ft && tmuxinator local"
alias ft-stop="tmux kill-session -t fantasy_toolbox"

alias rtyl-lnd="cd ~/projects/arterial/landing-page"
alias rtyl-lnd-start="rtyl-lnd && tmuxinator local"
alias rtyl-lnd-stop="tmux kill-session -t arterial_landingPage"

alias renovo="cd ~/projects/renovo/safelum_back_office_v0"
alias renovo-start="renovo && tmuxinator local"
alias renovo-stop="tmux kill-session -t safelum_back_office_v0"

alias ccil="cd ~/projects/arterial/ccil"
alias ccil-start="ccil && tmuxinator local"
alias ccil-stop="tmux kill-session -t ccil"

alias dots="cd ~/dotfiles/"

# clean branches local
alias git-cbl="git co master && git branch --merged | grep -v '\*\|master\|develop' | xargs -n 1 git branch -d"
# clean branches remote
alias git-cbr="git co master && git branch -r --merged | grep -v '\*\|master\|develop' | sed 's/origin\///' | xargs -n 1 git push --delete origin"



### PERMISSIONS
#------------------------------------------------------------

  # DISABLED. Left here for reference.
  #
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
  # must change the user's default umask to 002:

# umask 002


### SET UP PYENV
#------------------------------------------------------------
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


### SET UP RBENV
#------------------------------------------------------------
eval "$(rbenv init -)"
export RBENV_VERSION=3.3.0


### SnowSQL Setup
#------------------------------------------------------------

alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql


### SOURCING
#------------------------------------------------------------

. ~/.bash_colors

# enable git tab completion
if [[ -e ~/.git-completion.bash ]]; then
  . ~/.git-completion.bash
fi

# set up nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


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

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH

# Added by rust installer 
. "$HOME/.cargo/env"
