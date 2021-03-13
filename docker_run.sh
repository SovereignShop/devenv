#!/usr/bin/env bash
set -euo pipefail

DIR=$(pwd)

docker run\
       --rm\
       -it\
       --name games-dock-emacs\
       --volume $SSH_AUTH_SOCK:/ssh-agent\
       --env SSH_AUTH_SOCK=/ssh-agent\
       -e DISPLAY=unix$DISPLAY\
       -e XAUTH=${HOME}/.Xauthority\
       --mount type=bind,src=${DIR},dst=${HOME}/Workspace\
       -v /tmp/.X11-unix:/tmp/.X11-unix:ro\
       -v ${XAUTHORITY}:${HOME}/.Xauthority\
       -v ${HOME}/.gitconfig:${HOME}/.gitconfig\
       -v ${HOME}/.local:${HOME}/.local\
       -v ${HOME}/.bashrc:${HOME}/.bashrc\
       -v ${HOME}/.oh-my-zsh:${HOME}/.oh-my-zsh\
       -v ${HOME}/.zsh_history:${HOME}/.zsh_history\
       -v ${HOME}/.zshrc:${HOME}/.zshrc\
       -v ${HOME}/.ssh/:${HOME}/.ssh\
       -v ${DIR}/modules/doom.d:${HOME}/.doom.d\
       -v ${DIR}/modules/emacs.d:${HOME}/.emacs.d\
       gamedev:latest emacs
