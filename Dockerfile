FROM ubuntu:20.04

ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    SSH_PORT=2222
EXPOSE $VNC_PORT $NO_VNC_PORT $SSH_PORT

ENV HOME=/home/default \
    TERM=xterm \
    DOCKER_DIR=/docker \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword

COPY setup.sh $DOCKER_DIR/
RUN /bin/bash $DOCKER_DIR/setup.sh
COPY Xvnc-session /etc/X11/Xvnc-session
RUN chmod 755 /etc/X11/Xvnc-session
COPY startup.sh $DOCKER_DIR/
COPY sshd_config /etc/ssh/sshd_config

RUN useradd -ms /bin/bash default
WORKDIR $HOME
USER default
COPY .icewm $HOME/.icewm/
USER root
RUN apt-get update && apt-get install git && apt-get install nano && apt-get install net-tools && apt-get install iputils-ping
RUN git clone https://github.com/roboime/SSL_AI.git
RUN cd SSL_AI && git checkout robocup2021_adjusts && git pull
USER default

ENTRYPOINT ["/docker/startup.sh"]
