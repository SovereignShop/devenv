#!/usr/bin/env bash
set -euo pipefail

DIR=$(pwd)

echo ${DIR} ${HOME}

docker run\
       --rm\
       -it\
       --privileged\
       --name games-dock-emacs\
       --volume $SSH_AUTH_SOCK:/ssh-agent\
       --env SSH_AUTH_SOCK=/ssh-agent\
       -e DISPLAY=host.docker.internal:0.0\
       -e XAUTH=${HOME}/.Xauthority\
       --mount type=bind,src=${DIR},dst=${HOME}/Workspace\
       --mount type=bind,src=${HOME}/.zshrc,dst=${HOME}/.zshrc\
       -v /tmp/.X11-unix:/tmp/.X11-unix:rw\
       -v ${HOME}/.telega:${HOME}/.telega\
       -v ${HOME}/.local:${HOME}/.local\
       -v ${HOME}/.lein:${HOME}/.lein\
       -v ${HOME}/.cljs:${HOME}/.cljs\
       -v ${HOME}/.clojure:${HOME}/.clojure\
       -v ${HOME}/.m2:${HOME}/.m2\
       -v ${HOME}/.bashrc:${HOME}/.bashrc\
       -v ${HOME}/.oh-my-zsh:${HOME}/.oh-my-zsh\
       -v ${HOME}/.zsh_history:${HOME}/.zsh_history\
       -v ${HOME}/.ssh/:${HOME}/.ssh\
       -v ${HOME}/.mozilla:${HOME}/.mozilla\
       -v ${DIR}/modules/doom.d:${HOME}/.doom.d\
       -v ${DIR}/modules/emacs.d:${HOME}/.emacs.d\
       gamedev:latest emacs -fs -L /emacs-application-framework --eval "(require 'eaf)"
