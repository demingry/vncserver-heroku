FROM hzunadocker/alpine:novnc
#or your built image

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


EXPOSE 6080


CMD ["run_novnc"]
