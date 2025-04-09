#/bin/bash

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/

echo '
deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main
' | tee /etc/apt/sources.list.d/vscode.list

wget -qO- https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | gpg --dearmor > /usr/share/keyrings/brave-browser-archive-keyring.gpg

install -o root -g root -m 644 /usr/share/keyrings/brave-browser-archive-keyring.gpg /etc/apt/trusted.gpg.d/brave-browser.gpg

echo '
deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main
' | tee /etc/apt/sources.list.d/brave-browser-release.list

apt-get -qqy update && apt-get -qqy install htop terminator software-properties-common \
    gpg-agent apt-transport-https brave-browser \
    papirus-icon-theme code fonts-lohit-beng-bengali \
    nemo mesa-utils git nano neofetch

wget -O /tmp/wps-office.deb https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/11723/wps-office_11.1.0.11723.XA_amd64.deb
apt-get -qqy update && apt-get -qqy install /tmp/wps-office.deb

bash /opt/bin/apt_clean.sh
