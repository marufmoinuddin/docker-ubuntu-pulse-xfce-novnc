#/bin/bash

if [ "${GUI}" == "xfce" ]
then
    bash /opt/bin/apt_install.sh \
        xfce4 xfce4-goodies \
    && bash /opt/bin/apt_clean.sh

    cat <<EOT >> /opt/bin/start-ui.sh
#!/usr/bin/env bash
/usr/bin/startxfce4
EOT

fi
