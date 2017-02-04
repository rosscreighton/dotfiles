### TERMINAL PREFS
#------------------------------------------------------------

export HISTCONTROL=ignoreboth:erasedups
export CLICOLOR=1


## ALIASES
#------------------------------------------------------------

alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"

alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'

alias gitx="open -a gitx ./"

alias ol="cd ~/projects/outland"
alias vu="vagrant up"
alias vs="vagrant ssh"

alias dots="cd ~/dotfiles/"


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

# set up nvm
export NVM_DIR="$HOME/.nvm"

if which brew &> /dev/null; then
  . $(brew --prefix nvm)/nvm.sh
fi


### CUSTOM COMMAND PROMPT
#------------------------------------------------------------

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1]/"
}

function parse_hg_branch {
  hg branch 2> /dev/null | sed -e "s/\(.*\)/[\1]/"
}

function parse_jobs_count {
  jobs | wc -l
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

  if [ parse_jobs_count > 0 ]; then
    PS1+="\[${Blue}\](\j)\[${Color_Off}\] "
  fi
  
  # Is it bad?
  if [ $EXIT != 0 ]; then
    PS1+="\[${Red}\]→ $EXIT\[${Color_Off}\] "      # Add red if exit code non 0
  fi

  PS1+="$ "
}

export PROMPT_COMMAND=__prompt_command
