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

# check and update the window size after each command and, if necessary,
shopt -s checkwinsize


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac


if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

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

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# seperate alias file
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi





# MY SETUP
# time format
export TIMEFORMAT=$'\033[01;30mTime: %R s\033[00m'


# normal run (noinp, noout)
r() {
    g++ "$1.cpp" -std=c++17 -O2 -Wall -Wextra \
        -fdiagnostics-color=always \
        -o /tmp/program || return

    time { /tmp/program; echo; echo; }
	echo
}

# debug
d() {
    g++ "$1.cpp" -std=c++17 -g \
        -fsanitize=address,undefined \
        -Wall -Wextra \
        -fdiagnostics-color=always \
        -o /tmp/program || return

    /tmp/program
	echo
}

# run with .inp (inp, noout)
ri() {
	g++ "$1.cpp" -std=c++17 -O2 -Wall -Wextra \
		-fdiagnostics-color=always \
		-o /tmp/program || return

		time { /tmp/program < "$1.inp"; echo; echo; }
		echo
}


# my alias
alias cls='clear'
e() {
	nvim-qt.exe "$(wslpath -w "$1")" >/dev/null 2>&1 &
}
