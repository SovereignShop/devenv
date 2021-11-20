#!/usr/bin/env bash

set -euo pipefail

# System dependencies
sudo apt -y install git aria2 wmctrl xdotool
sudo apt -y install libglib2.0-dev

# Missing in Ubuntu: filebrowser-bin

sudo apt -y install python3-pyqt5 python3-sip python3-pyqt5.qtwebengine \
     python3-qrcode python3-feedparser \
     python3-markdown python3-qtconsole python3-pygit2

echo "Installing npm dependencies..."
npm install

python3 -m pip install pymupdf epc retrying
