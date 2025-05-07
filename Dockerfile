FROM docker.io/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_PRIORITY=high

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
    # UI Requirements
    xvfb \
    xterm \
    xdotool \
    scrot \
    imagemagick \
    sudo \
    x11vnc \
    xfce4 \
    xfce4-terminal \
    xfce4-goodies \
    # Python/pyenv reqs
    build-essential \
    libssl-dev  \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    curl \
    git \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    # Network tools
    net-tools \
    netcat \
    # Proxy and process management
    nginx \
    supervisor \
    # PPA req
    software-properties-common && \
    # Userland apps
    sudo add-apt-repository ppa:mozillateam/ppa && \
    sudo apt-get install -y --no-install-recommends \
    chromium-browser \
    libreoffice \
    x11-apps \
    xpdf \
    gedit \
    galculator \
    wget \
    xdg-utils \
    libvulkan1 \
    fonts-liberation \
    unzip && \
    apt-get clean

# install chromium & ncat for proxying the remote debugging port
RUN add-apt-repository -y ppa:xtradeb/apps
RUN apt update -y && apt install -y chromium ncat

# Install noVNC
RUN git clone --branch v1.5.0 https://github.com/novnc/noVNC.git /opt/noVNC && \
    git clone --branch v0.12.0 https://github.com/novnc/websockify /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# setup desktop env & app
ENV DISPLAY_NUM=1
ENV HEIGHT=768
ENV WIDTH=1024

# Placeholder for custom wallpaper
RUN mkdir -p /tmp/wallpapers

COPY ./entrypoint.sh /entrypoint.sh
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY wallpaper.png /wallpaper.png

# Disable power manager to prevent error dialogs
RUN mkdir -p /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/
COPY xfce4-power-manager.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/

# Add script to completely disable power manager
COPY disable-power-manager.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/disable-power-manager.sh

# Create startup directory and add power manager disabling to autostart
RUN mkdir -p /etc/xdg/autostart
RUN echo "[Desktop Entry]\nType=Application\nName=DisablePowerManager\nExec=/usr/local/bin/disable-power-manager.sh\nTerminal=false\nHidden=false" > /etc/xdg/autostart/disable-power-manager.desktop

# Remove power manager from XFCE panel settings
RUN mkdir -p /etc/xdg/xfce4/panel
RUN sed -i '/power-manager/d' /etc/xdg/xfce4/panel/* 2>/dev/null || true

ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]