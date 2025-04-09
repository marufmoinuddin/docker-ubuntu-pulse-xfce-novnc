#/bin/bash

bash /opt/bin/apt_install.sh \
    htop terminator software-properties-common gpg-agent apt-transport-https

add-apt-repository -y ppa:mozillateam/ppa
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | tee /etc/apt/preferences.d/mozilla-firefox

bash /opt/bin/apt_install.sh firefox

bash /opt/bin/apt_install.sh papirus-icon-theme

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/

echo '
deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main
' | tee /etc/apt/sources.list.d/vscode.list

bash /opt/bin/apt_install.sh code fonts-lohit-beng-bengali nemo mesa-utils neofetch 

wget -O /tmp/wps-office.deb https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/11723/wps-office_11.1.0.11723.XA_amd64.deb
apt install -y /tmp/wps-office.deb

bash /opt/bin/apt_clean.sh
