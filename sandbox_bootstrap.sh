#!/usr/bin/env bash
set -euo pipefail

# Remap caps to escape.
setxkbmap -option caps:escape

# export PYTHONPATH=${HOME}/Workspace/shining_software/src:${PYTHONPATH};
export PATH=/opt/gnu/bin:${HOME}/.local/bin:${HOME}/.emacs.d/bin:${HOME}/Workspace/bin:${PATH};
~/.emacs.d/bin/doom sync;

exec "$@"
