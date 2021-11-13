# Based on 
# - https://github.com/tombenke/darduino
# - https://github.com/bannsec/autoPwn-stage-Ghidra
# - https://github.com/bskaggs/ghidra-docker/blob/master/Dockerfile
#
# Moved version, sha256sum and user to run script for easier update.
FROM debian:buster

RUN export user=$USER \
    && apt-get update \
	&& apt-get install -y \
        openambit \
        git \
        python \
        sudo \
    && mkdir -p /etc/sudoers.d \
    && touch /etc/sudoers.d/andreic \
    && echo "andreic ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/andreic \
    && chmod 0440 /etc/sudoers.d/andreic \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*



ENV DISPLAY :1.0

#CMD /bin/bash -i -c "QT_X11_NO_MITSHM=1 openambit"
