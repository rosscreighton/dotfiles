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

alias dots="cd ~/dotfiles/"

### PROJECT SESSIONS
#------------------------------------------------------------
# Projects are registered in ~/.projects.conf, a machine-local file
# that is NOT tracked in this repo. Line format:
#   <name> <path> <active: yes|no>
# For each project this generates three aliases: <name> (cd to it),
# <name>-start (launch its tmuxinator session), <name>-stop (kill it).
# `projects-up` starts the tmux session for every active project,
# detached, skipping ones already running.

PROJECTS_CONF="$HOME/.projects.conf"

# Path to the project-local tmuxinator config, if any
_project_conf_file() {
  if [ -f "$1/.tmuxinator.yml" ]; then
    echo "$1/.tmuxinator.yml"
  elif [ -f "$1/.tmuxinator.rc.yml" ]; then
    echo "$1/.tmuxinator.rc.yml"
  else
    return 1
  fi
}

# Session name declared in a tmuxinator config
_project_session() {
  awk '$1 == "name:" { print $2; exit }' "$1"
}

project_start() {
  local conf
  conf=$(_project_conf_file "$1") || { echo "no .tmuxinator*.yml in $1" >&2; return 1; }
  cd "$1" && tmuxinator start -p "$conf"
}

project_stop() {
  local conf
  conf=$(_project_conf_file "$1") || { echo "no .tmuxinator*.yml in $1" >&2; return 1; }
  tmux kill-session -t "=$(_project_session "$conf")"
}

projects_up() {
  local name path active conf session
  if [ ! -f "$PROJECTS_CONF" ]; then
    echo "$PROJECTS_CONF not found" >&2
    return 1
  fi
  while read -r name path active _; do
    case "$name" in ''|\#*) continue ;; esac
    [ "$active" = "yes" ] || continue
    path="${path/#\~/$HOME}"
    conf=$(_project_conf_file "$path") || { echo "SKIP  $name — no tmuxinator config in $path"; continue; }
    session=$(_project_session "$conf")
    if tmux has-session -t "=$session" 2>/dev/null; then
      echo "OK    $session — already running"
    elif (cd "$path" && tmuxinator start -p "$conf" --no-attach >/dev/null 2>&1); then
      echo "UP    $session"
    else
      echo "FAIL  $session — tmuxinator start failed"
    fi
  done < "$PROJECTS_CONF"
}
alias projects-up="projects_up"

if [ -f "$PROJECTS_CONF" ]; then
  while read -r _pj_name _pj_path _pj_active _; do
    case "$_pj_name" in ''|\#*) continue ;; esac
    alias "$_pj_name"="cd $_pj_path"
    alias "$_pj_name-start"="project_start $_pj_path"
    alias "$_pj_name-stop"="project_stop $_pj_path"
  done < "$PROJECTS_CONF"
  unset _pj_name _pj_path _pj_active
fi

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
