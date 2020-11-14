FROM gitpod/workspace-full

USER gitpod

### Install Flutter
RUN set -ex; \
    mkdir ~/development; \
    cd ~/development; \
    git clone https://github.com/flutter/flutter.git -b stable

ENV PATH="$PATH:/home/gitpod/development/flutter/bin"

RUN set -ex; \
    flutter channel beta; \
    flutter config --enable-web; \
    flutter precache
