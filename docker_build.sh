#!/usr/bin/env bash
set -euo pipefail

docker build --rm -t gamedev:latest\
    --build-arg base_image="$@"\
    --build-arg UNAME=$USER\
    --build-arg GNAME=$USER\
    --build-arg UHOME=$HOME\
    --build-arg UID=$UID\
    --build-arg GID=$UID\
    --build-arg WORKSPACE=${HOME}/Workspace\
    .
