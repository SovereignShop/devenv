#!/usr/bin/env bash
set -euo pipefail

docker run\
       --rm\
       -it\
       --name brain-dock-emacs\
       --volume $SSH_AUTH_SOCK:/ssh-agent\
       --env SSH_AUTH_SOCK=/ssh-agent\
       -e DISPLAY=unix$DISPLAY\
       -e XAUTH=${HOME}/.Xauthority\
       --mount type=bind,src=${HOME}/Workspace,dst=${HOME}/Workspace\
       --mount type=volume,dst=${HOME}/Workspace/shining_software/build\
       -v /tmp/.X11-unix:/tmp/.X11-unix:ro\
       -v /usr/share/fonts:/usr/share/fonts\
       -v ${XAUTHORITY}:${HOME}/.Xauthority\
       -v ${HOME}/Workspace/shining_software/src:/opt/shining_software\
       -v ${HOME}/Workspace/brain_dock:${HOME}/Workspace/brain_dock\
       -v ${HOME}/.gitconfig:${HOME}/.gitconfig\
       -v ${HOME}/.local:${HOME}/.local\
       -v ${HOME}/.org-jira:${HOME}/.org-jira\
       -v ${HOME}/.bashrc:${HOME}/.bashrc\
       -v ${HOME}/.oh-my-zsh:${HOME}/.oh-my-zsh\
       -v ${HOME}/.zsh_history:${HOME}/.zsh_history\
       -v ${HOME}/.zshrc:${HOME}/.zshrc\
       -v ${HOME}/.ssh/:${HOME}/.ssh\
       -v ${HOME}/.doom.d:${HOME}/.doom.d\
       -v ${HOME}/.emacs.d:${HOME}/.emacs.d\
       -v ${HOME}/.aws:/${HOME}/.aws\
       -v ${HOME}/org:${HOME}/org\
       shining:latest emacs
