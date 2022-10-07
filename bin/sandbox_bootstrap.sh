#!/usr/bin/env bash
set -euo pipefail

# Remap caps to escape.
# setxkbmap -option caps:escape
# xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

# export PYTHONPATH=${HOME}/Workspace/shining_software/src:${PYTHONPATH};
export PATH=/opt/gnu/bin:${HOME}/.local/bin:${HOME}/.emacs.d/bin:${HOME}/Workspace/bin:${PATH};
if [ -d ~/.emacs.d/.local ]; then
    doom sync;
else
    cd ~/.emacs.d/bin && ./doom install && cd ~/;
fi

echo $UNAME
xhost +SI:localuser:$UNAME

# Set themes, etc.
# gnome-settings-daemon &

# Set fallback cursor.
xsetroot -cursor_name left_ptr

# Set keyboard repeat rate.
xset r rate 200 60

# If Emacs is started in server mode, `emacsclient` is a convenient way to
# edit files in place (used by e.g. `git commit`).
export VISUAL=emacsclient
export EDITOR="$VISUAL"

# Finally launch emacs.
# exec dbus-launch --exit-with-session "$@"
exec kitty --hold --single-instance --start-as=fullscreen "$@"
