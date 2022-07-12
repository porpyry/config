#!/bin/sh

#/etc/zsh/zshenv
#export XDG_CONFIG_HOME=$HOME/.config
#export XDG_CACHE_HOME=$HOME/.cache
#export XDG_DATA_HOME=$HOME/.local/share
#export XDG_STATE_HOME=$HOME/.local/state
#export ZDOTDIR=$HOME/.config/zsh
#export PATH=$HOME/.local/bin:$PATH
#export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority

export GRIPHOME=$XDG_CONFIG_HOME/grip
export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/pythonrc
export LESSHISTFILE=$XDG_CACHE_HOME/less/history
export GNUPGHOME=$XDG_DATA_HOME/gnupg

export GTK_IM_MODULE=nimf
export QT4_IM_MODULE=nimf
export QT_IM_MODULE=nimf
export XMODIFIERS=@im=nimf

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export EDITOR=nvim

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx > /dev/null 2>&1
fi
