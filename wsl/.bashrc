# author : kralight

# if not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# history config
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# less
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
# my alias
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias q='exit'

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# time format
export TIMEFORMAT=$'\n\033[01;30m[Time: %R s]\033[00m'
# set default code editor
export EDITOR=nvim
export VISUAL=nvim

# normal run (noinp, noout)
r() {
    g++ "$1.cpp" -std=c++17 -O2 -Wall -Wextra \
        -fdiagnostics-color=always \
        -o /tmp/program || return

    time { /tmp/program; echo; }
}

# run with .inp (inp, noout)
ri() {
	g++ "$1.cpp" -std=c++17 -O2 -Wall -Wextra \
		-fdiagnostics-color=always \
		-o /tmp/program || return

		time { /tmp/program < "$1.inp"; echo; }
}
