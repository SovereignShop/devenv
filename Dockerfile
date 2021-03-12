FROM ubuntu:20.04
MAINTAINER John Collins <jmicahc@gmail.com>

RUN apt-get update && apt-get install -y software-properties-common

# basic stuff
RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
    && apt-get update && apt-get install \
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
RUN pip3 install --upgrade pip && pip3 install ipython ipdb pylint pyflakes flake8 python-language-server pytest black
RUN python3 -m pip install -U git+git://github.com/python/mypy.git

copy asenvuser /usr/local/sbin/
# only for sudoers
run chown root /usr/local/sbin/asenvuser \
    && chmod 700  /usr/local/sbin/asenvuser

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

CMD ["bash"]
