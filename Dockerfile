FROM alpine

COPY config /etc/skel/.config

RUN set -xe \
  && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
  && echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing"  >> /etc/apk/repositories \
  && apk --update --no-cache add xvfb x11vnc@testing xfce4 xfce4-terminal paper-icon-theme arc-theme@testing chromium python2 bash sudo htop procps curl \
  && mkdir -p /usr/share/wallpapers \
  && curl https://img2.goodfon.com/original/2048x1820/3/b6/android-5-0-lollipop-material-5355.jpg -o /usr/share/wallpapers/android-5-0-lollipop-material-5355.jpg \
  && echo "CHROMIUM_FLAGS=\"--no-sandbox --no-first-run --disable-gpu\"" >> /etc/chromium/chromium.conf \
  && addgroup alpine \
  && adduser -G alpine -s /bin/bash -D alpine \
  && echo "alpine:alpine" | /usr/sbin/chpasswd \
  && echo "alpine ALL=NOPASSWD: ALL" >> /etc/sudoers


RUN apk --no-cache add ca-certificates wget && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-bin-2.25-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk && \
    apk add glibc-bin-2.25-r0.apk glibc-i18n-2.25-r0.apk glibc-2.25-r0.apk

COPY ./locale.md /locale.md

RUN cat locale.md | xargs -i /usr/glibc-compat/bin/localedef -i {} -f UTF-8 {}.UTF-8

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

USER alpine

ENV USER=alpine \
    DISPLAY=:1 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    HOME=/home/alpine \
    TERM=xterm \
    SHELL=/bin/bash \
    VNC_PASSWD=alpinelinux \
    VNC_PORT=5900 \
    VNC_RESOLUTION=1920x1080 \
    VNC_COL_DEPTH=24  \
    NOVNC_PORT=6080 \
    NOVNC_HOME=/home/alpine/noVNC 

RUN set -xe \
  && sudo apk update \
  && sudo apk add ca-certificates wget \
  && sudo update-ca-certificates \
  && mkdir -p $NOVNC_HOME/utils/websockify \
  && wget -qO- https://github.com/novnc/noVNC/archive/v0.6.2.tar.gz | tar xz --strip 1 -C $NOVNC_HOME \
  && wget -qO- https://github.com/novnc/websockify/archive/v0.6.1.tar.gz | tar xzf - --strip 1 -C $NOVNC_HOME/utils/websockify \
  && chmod +x -v $NOVNC_HOME/utils/*.sh \
  && ln -s $NOVNC_HOME/vnc_auto.html $NOVNC_HOME/index.html \
  && sudo apk del wget

WORKDIR $HOME
EXPOSE $VNC_PORT $NOVNC_PORT

COPY run_novnc /usr/bin/
