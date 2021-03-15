#!/usr/bin/env bash
set -euo pipefail

# export PYTHONPATH=${HOME}/Workspace/shining_software/src:${PYTHONPATH};
export PATH=/opt/gnu/bin:${HOME}/.local/bin:${HOME}/.emacs.d/bin:${PATH};
~/.emacs.d/bin/doom sync;

exec "$@"
