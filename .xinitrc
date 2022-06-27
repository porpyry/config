#!/bin/sh

[ -f $XDG_CONFIG_HOME/X11/xprofile ] && . $XDG_CONFIG_HOME/X11/xprofile
[ -f $XDG_CONFIG_HOME/X11/xresources ] && xrdb -merge $XDG_CONFIG_HOME/X11/xresources
[ -f $XDG_CONFIG_HOME/X11/xmodmap ] && xmodmap $XDG_CONFIG_HOME/X11/xmodmap
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi
exec bspwm > /dev/null 2>&1
