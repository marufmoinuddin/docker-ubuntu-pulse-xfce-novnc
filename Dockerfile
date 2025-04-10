FROM debian:bookworm

# Fix CMD duplication issue
# CMD ["bash"] is only needed once at the end

ARG GUI=xfce
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    USERNAME=debian \
    HOME=/home/debian \
    GUI=xfce \
    SCREEN_WIDTH=1600 \
    SCREEN_HEIGHT=900 \
    SCREEN_DEPTH=24 \
    SCREEN_DPI=96 \
    DISPLAY=:0 \
    DISPLAY_NUM=0 \
    FFMPEG_UDP_PORT=10000 \
    WEBSOCKIFY_PORT=6900 \
    VNC_PORT=5900 \
    AUDIO_SERVER=1699 \
    VNC_PASSWD=password

# Fix package repository and permission issues
RUN mkdir -p /var/lib/apt/lists/partial && \
    chmod 1777 /var/lib/apt/lists/partial && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo 'APT::Sandbox::User "root";' > /etc/apt/apt.conf.d/01-sandbox-disable && \
    apt-get update --allow-insecure-repositories && \
    apt-get install -y --allow-unauthenticated ca-certificates gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install basic utilities
RUN apt-get update --allow-insecure-repositories && \
    apt-get install -y --allow-unauthenticated unzip zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy opt directory
COPY opt/ /opt/

# Install GUI components
RUN apt-get update --allow-insecure-repositories && \
    apt-get install -y --allow-unauthenticated \
    sudo supervisor dbus-x11 xvfb bsdextrautils x11vnc x11-xserver-utils \
    tigervnc-standalone-server tigervnc-common novnc websockify \
    wget curl unzip gettext ca-certificates libnss3-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    bash /opt/bin/apt_clean.sh

# Install audio components
RUN apt-get update --allow-insecure-repositories && \
    apt-get install -y --no-install-recommends --allow-unauthenticated \
    pulseaudio pavucontrol alsa-base ffmpeg nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    bash /opt/bin/apt_clean.sh

# Rest of your Dockerfile remains the same
RUN chmod +x /dev/shm
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

RUN groupadd $USERNAME --gid 1001 && \
    useradd $USERNAME --create-home --gid 1001 --shell /bin/bash --uid 1001 && \
    usermod -a -G sudo $USERNAME && \
    mkdir -p /home/$USERNAME/.config && \
    echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo "$USERNAME:$USERNAME" | chpasswd

RUN mkdir -p /home/$USERNAME/.cache && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.cache

RUN rm -rf /home/$USERNAME/.config
COPY xfce4_backup/ /home/$USERNAME/.config/
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME/.config

RUN rm -rf /root/.config
COPY xfce4_backup/ /root/.config/
RUN chown -R root:root /root/.config

COPY etc/supervisor/ /etc/supervisor/
COPY etc/nginx/conf.d/ /etc/nginx/conf.d/
RUN bash /opt/bin/install_gui.sh
RUN bash /opt/bin/install_utils.sh
RUN bash /opt/bin/setup_audio.sh

COPY usr/share/ /usr/share/

RUN bash /opt/bin/relax_permission.sh
RUN sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" /usr/share/novnc/app/ui.js
RUN apt-get update --allow-insecure-repositories && \
    apt-get install -y --allow-unauthenticated xfce4-goodies && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    bash /opt/bin/apt_clean.sh

USER debian
CMD ["/opt/bin/entry_point.sh"]