FROM ubuntu:20.04
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
    && apt-get update && apt-get install -y emacs27\
# Cleanup
    && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

run curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.0/ripgrep_12.1.0_amd64.deb\
    && dpkg -i ripgrep_12.1.0_amd64.deb\
    && rm ripgrep_12.1.0_amd64.deb

# Install oh-my-zsh
RUN \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Pip installs
RUN python3 -m pip install --upgrade pip && python3 -m pip install ipython ipdb pylint pyflakes flake8 python-language-server pytest black
RUN python3 -m pip install -U git+git://github.com/python/mypy.git


COPY asEnvUser /usr/local/sbin/
# Only for sudoers
RUN chown root /usr/local/sbin/asEnvUser \
    && chmod 700  /usr/local/sbin/asEnvUser

COPY sandbox_bootstrap.sh /usr/bin/

# Install latest cmake
ADD https://cmake.org/files/v3.12/cmake-3.12.0-Linux-x86_64.sh /cmake-3.12.0-Linux-x86_64.sh
RUN mkdir /opt/cmake
RUN sh /cmake-3.12.0-Linux-x86_64.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

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
COPY install-latest-clojure-lsp.sh ./
RUN ./install-latest-clojure-lsp.sh;\
    rm ./install-latest-clojure-lsp.sh

# Clojure Kondo for linting: https://github.com/clj-kondo/clj-kondo/blob/master/doc/install.md
RUN curl -sLO https://raw.githubusercontent.com/clj-kondo/clj-kondo/master/script/install-clj-kondo;\
    chmod +x install-clj-kondo;\
    ./install-clj-kondo;\
    rm ./install-clj-kondo;

# Install Node.js.
RUN apt-get update && apt-get install -y nodejs npm

RUN npm install --save-dev shadow-cljs

ENTRYPOINT ["asEnvUser"]
CMD ["/usr/bin/bash", "-c", "emacs"]
