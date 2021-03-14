#!/usr/bin/env bash
set -euo pipefail

DIR=$(pwd)

docker build --rm -t gamedev:latest\
    --build-arg UNAME=${USER}\
    --build-arg GNAME=${USER}\
    --build-arg UHOME=${HOME}\
    --build-arg UID=${UID}\
    --build-arg GID=${UID}\
    --build-arg WORKSPACE=${HOME}/Workspace\
    .
