#!/usr/bin/env bash
set -euo pipefail

# Remap caps to escape.
# setxkbmap -option caps:escape
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

# export PYTHONPATH=${HOME}/Workspace/shining_software/src:${PYTHONPATH};
export PATH=/opt/gnu/bin:${HOME}/.local/bin:${HOME}/.emacs.d/bin:${HOME}/Workspace/bin:${PATH};
cd ~/.emacs.d/bin && ./doom install && cd ~/;

exec "$@"
