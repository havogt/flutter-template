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
    # once https://github.com/flutter/flutter/issues/53884 is fixed remove version and switch back to upgrade
    # flutter version v1.15.17; \
    flutter upgrade; \
    flutter config --enable-web; \
    flutter precache
