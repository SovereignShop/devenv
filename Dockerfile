FROM ubuntu:22.04
MAINTAINER John Collins <jmicahc@gmail.com>

# XXX: X11 forwardig
# Fix "Couldn't register with accessibility bus" error message
ENV NO_AT_BRIDGE=1
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y software-properties-common

# basic stuff
RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
    && apt-get update && apt-get install \
    python3-pip\
    bash \
    build-essential \
    dbus-x11 \
    fontconfig \
    git \
    gzip \
    language-pack-en-base \
    aptitude \
    libgl1-mesa-glx \
    make \ 
    sudo \
    tar \
    unzip \
    rlwrap \
    zsh \
    libtool \
    libtool-bin \
    curl \
    pkg-config \
    telegram-desktop \
    locate \
# su-exec
    && git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
    && cd /tmp/su-exec \
    && make \
    && chmod 770 su-exec \
   && mv ./su-exec /usr/local/sbin/ \
# Cleanup
    && apt-get purge build-essential \
    && apt-get autoremove \
    && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

# Emacs
RUN apt-get update\
    && apt-add-repository ppa:kelleyk/emacs\
    && apt-get update && apt-get install -y emacs28\
# Cleanup
    && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

run curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb\
    && dpkg -i ripgrep_13.0.0_amd64.deb\
    && rm ripgrep_13.0.0_amd64.deb

# Install oh-my-zsh
RUN \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Pip installs
RUN python3 -m pip install --upgrade pip && python3 -m pip install ipython ipdb pylint pyflakes flake8 python-language-server pytest black mypy numpy
# RUN python3 -m pip install -U git+git://github.com/python/mypy.git

# Install latest cmake
# COPY pkg/cmake-3.12.0-Linux-x86_64.sh /cmake-3.12.0-Linux-x86_64.sh
# RUN mkdir /opt/cmake
# RUN sh /cmake-3.12.0-Linux-x86_64.sh --prefix=/opt/cmake --skip-license
# RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

# Set the CMake version to be installed
ARG CMAKE_VERSION="3.22.1"

# Update package list, install required dependencies, download and extract CMake, build and install CMake, and clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential ca-certificates curl libssl-dev wget && \
    cd /tmp && \
    wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz && \
    tar -xzvf cmake-${CMAKE_VERSION}.tar.gz && \
    cd cmake-${CMAKE_VERSION} && \
    ./bootstrap && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/cmake-${CMAKE_VERSION} /tmp/cmake-${CMAKE_VERSION}.tar.gz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


COPY bin/tuntox /usr/bin/

RUN apt-get update && apt-get install -y firefox

ARG UNAME
ARG GNAME
ARG UHOME
ARG UID
ARG GID
ARG WORKSPACE
ENV UNAME=$UNAME\
    GNAME=$GNAME \
    UHOME=$UHOME \
    UID=$UID \
    GID=$GID \
    WORKSPACE=$WORKSPACE \
    SHELL="/bin/zsh"

# Install Java 11
# Copied from: https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/11/jdk/ubuntu/Dockerfile.hotspot.releases.full

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_VERSION jdk-11.0.10+9

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       aarch64|arm64) \
         ESUM='420c5d1e5dc66b2ed7dedd30a7bdf94bfaed10d5e1b07dc579722bf60a8114a9'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.10%2B9/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.10_9.tar.gz'; \
         ;; \
       armhf|armv7l) \
         ESUM='34908da9c200f5ef71b8766398b79fd166f8be44d87f97510667698b456c8d44'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.10%2B9/OpenJDK11U-jdk_arm_linux_hotspot_11.0.10_9.tar.gz'; \
         ;; \
       ppc64el|ppc64le) \
         ESUM='e1d130a284f0881893711f17df83198d320c16f807de823c788407af019b356b'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.10%2B9/OpenJDK11U-jdk_ppc64le_linux_hotspot_11.0.10_9.tar.gz'; \
         ;; \
       s390x) \
         ESUM='b55e5d774bcec96b7e6ffc8178a17914ab151414f7048abab3afe3c2febb9a20'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.10%2B9/OpenJDK11U-jdk_s390x_linux_hotspot_11.0.10_9.tar.gz'; \
         ;; \
       amd64|x86_64) \
         ESUM='ae78aa45f84642545c01e8ef786dfd700d2226f8b12881c844d6a1f71789cb99'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.10%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.10_9.tar.gz'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

# ---- end Dockerfile.hotspot.releases.full ---

# Install Clojure
RUN curl -O https://download.clojure.org/install/linux-install-1.10.2.796.sh;\
    chmod +x linux-install-1.10.2.796.sh;\
    ./linux-install-1.10.2.796.sh;\
    rm ./linux-install-1.10.2.796.sh;

# Clojure LSP server
COPY bin/install-latest-clojure-lsp.sh ./
RUN ./install-latest-clojure-lsp.sh;\
    rm ./install-latest-clojure-lsp.sh

# Clojure Kondo for linting: https://github.com/clj-kondo/clj-kondo/blob/master/doc/install.md
RUN curl -sLO https://raw.githubusercontent.com/clj-kondo/clj-kondo/master/script/install-clj-kondo;\
    chmod +x install-clj-kondo;\
    ./install-clj-kondo;\
    rm ./install-clj-kondo;

# Install Node.js.
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g npm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash


WORKDIR /home/$UNAME/

# shadow-cljs for ClojureScript development
RUN npm install --save-dev shadow-cljs

# For VOIP client for telegram
RUN apt-get update && apt-get install -y gperf libopus-dev libpulse-dev libasound-dev libopus-dev ffmpeg graphviz

# Install TD for telegram client.
# RUN git clone https://github.com/tdlib/td.git \
#     && cd td\
#     && git reset --hard d161323858a782bc500d188b9ae916982526c262\
#     && mkdir build && cd build && cmake ../\
#     && make -j8\
#     && make install\
#     && cd ../../\
#     && rm -r td;

# Install support for voice-over-ip (Audio chats)
RUN curl -sLO http://deb.debian.org/debian/pool/main/libt/libtgvoip/libtgvoip_2.4.2.orig.tar.gz;\
    tar -xf libtgvoip_2.4.2.orig.tar.gz;\
    cd libtgvoip-2.4.2/;\
    ./configure;\
    make -j8;\
    make install;\
    cd ..;\
    rm -rf libtgvoip-2.4.2/ libtgvoip_2.4.2-1.debian.tar.xz

# Deps for Emacs Application Framework
# RUN git clone --depth=1 https://github.com/manateelazycat/emacs-application-framework
# COPY ./bin/install-eaf.sh /emacs-application-framework/install.sh
# RUN cd /emacs-application-framework && ./install.sh
# RUN python3 -m pip install pymupdf epc retrying

# sqlite3 for forge org-roam
RUN apt-get update && apt-get install sqlite3

COPY asEnvUser /usr/local/sbin/
# Only for sudoers
RUN chown root /usr/local/sbin/asEnvUser \
    && chmod 700  /usr/local/sbin/asEnvUser


# Install Git LFS (Large File Storage) for dlfp repo
RUN apt-get update && apt-get install git-lfs


# Install PDF tools
RUN apt-get update && apt-get install -y gir1.2-poppler-0.18 libcairo-script-interpreter2 libcairo2-dev libfontconfig1-dev\
    libfreetype-dev libfreetype6-dev libice-dev liblzo2-2 libpixman-1-dev libpng-tools libpoppler-glib8 libpoppler-cpp0v5\
    libpthread-stubs0-dev libsm-dev libx11-dev libxau-dev libxcb-render0-dev libxcb-shm0-dev libxcb1-dev libxdmcp-dev\
    libxext-dev libxrender-dev poppler-data x11proto-core-dev x11proto-dev x11proto-xext-dev xorg-sgml-doctools xtrans-dev

# Install Leinigen
RUN curl -sLO https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein;\
    mv lein /usr/bin;\
    chmod +x /usr/bin/lein;

RUN apt-get update && apt-get install -y wget

# MKL version 2020.0-088
RUN apt-get update && apt-get install -y intel-mkl

# Install Openscad
# RUN apt-get update && apt-get install -y openscad

RUN wget https://files.openscad.org/snapshots/OpenSCAD-2023.04.25.ai14946-x86_64.AppImage &&\
    chmod +x OpenSCAD-2023.04.25.ai14946-x86_64.AppImage &&\
    mv OpenSCAD-2023.04.25.ai14946-x86_64.AppImage /usr/local/bin

ENV OPENSCADPATH=/home/$UNAME/Workspace/modules/openscad
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

# ADD lib/lib* /usr/lib/x86_64-linux-gnu/
RUN ln -s /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 libOpenCL.so

# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin\
#     && mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600\
#     && wget http://developer.download.nvidia.com/compute/cuda/11.0.2/local_installers/cuda-repo-ubuntu2004-11-0-local_11.0.2-450.51.05-1_amd64.deb\
#     && sudo dpkg -i cuda-repo-ubuntu2004-11-0-local_11.0.2-450.51.05-1_amd64.deb\
#     && sudo apt-key add /var/cuda-repo-ubuntu2004-11-0-local/7fa2af80.pub\
#     && sudo apt-get update\
#     && sudo apt-get install -y cuda

# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin\
#     && sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600\
#     && wget https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda-repo-ubuntu2004-11-1-local_11.1.1-455.32.00-1_amd64.deb\
#     && sudo dpkg -i cuda-repo-ubuntu2004-11-1-local_11.1.1-455.32.00-1_amd64.deb\
#     && sudo apt-key add /var/cuda-repo-ubuntu2004-11-1-local/7fa2af80.pub\
#     && sudo apt-get update\
#     && sudo apt-get -y install cuda

# PCL Tools   pdal libpcl-dev
RUN apt-get update && apt-get install -y pcl-tools

# PlatformIO
RUN pip install -U platformio

# =======
# Klipper
RUN apt install -y gcc-arm-none-eabi avr-libc

RUN apt install -y kitty x11-xserver-utils

RUN git clone https://github.com/emscripten-core/emsdk.git &&\
    cd emsdk &&\
    ./emsdk install latest &&\
    ./emsdk activate latest

COPY ./bin/sandbox_bootstrap.sh /usr/bin/

ENTRYPOINT ["asEnvUser"]
CMD ["/usr/bin/bash", "-c", "emacs"]
