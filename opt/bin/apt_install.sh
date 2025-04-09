#/bin/bash

apt-get -qqy update \
&& apt-get -qqy install "$@"
