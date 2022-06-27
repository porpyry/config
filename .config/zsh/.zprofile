#!/bin/sh

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
