#!/usr/bin/env bash
set -euo pipefail

DIR=$(pwd)

docker run\
       --rm\
       --privileged\
       -it\
       -p 8080:8080\
       -p 9630:9630\
       --name games-dock-emacs\
       --volume $SSH_AUTH_SOCK:/ssh-agent\
       --device /dev/dri:/dev/dri\
       --env SSH_AUTH_SOCK=/ssh-agent\
       -e DISPLAY=unix$DISPLAY\
       -e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native \
       -e XAUTH=${HOME}/.Xauthority\
       --mount type=bind,src=${DIR},dst=${HOME}/Workspace\
       -v /tmp/.X11-unix:/tmp/.X11-unix:rw\
       -v /etc/timezone:/etc/timezone:ro\
       -v /etc/localtime:/etc/localtime:ro\
       -v /etc/machine-id:/etc/machine-id:ro\
       -v ${HOME}/.telega:${HOME}/.telega\
       -v ${XDG_RUNTIME_DIR}/pulse:${XDG_RUNTIME_DIR}/pulse \
       -v ${XAUTHORITY}:${HOME}/.Xauthority\
       -v ${HOME}/.gitconfig:${HOME}/.gitconfig\
       -v ${HOME}/.local:${HOME}/.local\
       -v ${HOME}/.lein:${HOME}/.lein\
       -v ${HOME}/.cljs:${HOME}/.cljs\
       -v ${HOME}/.clojure:${HOME}/.clojure\
       -v ${HOME}/.m2:${HOME}/.m2\
       -v ${HOME}/.bashrc:${HOME}/.bashrc\
       -v ${HOME}/.oh-my-zsh:${HOME}/.oh-my-zsh\
       -v ${HOME}/.zsh_history:${HOME}/.zsh_history\
       -v ${HOME}/.zshrc:${HOME}/.zshrc\
       -v ${HOME}/.ssh/:${HOME}/.ssh\
       -v ${HOME}/.mozilla:${HOME}/.mozilla\
       -v ${DIR}/modules/doom.d:${HOME}/.doom.d\
       -v ${DIR}/modules/emacs.d:${HOME}/.emacs.d\
       gamedev:latest emacs -fs
