# Based on 
# - https://github.com/tombenke/darduino
# - https://github.com/bannsec/autoPwn-stage-Ghidra
# - https://github.com/bskaggs/ghidra-docker/blob/master/Dockerfile
#
# Moved version, sha256sum and user to run script for easier update.
FROM openjdk:11-slim

ARG VERS
ARG USER
ARG SHA256
ARG FOLD

ENV HOME /home/$USER
WORKDIR /home/$USER

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 user=$USER && \
    mkdir -p /home/$USER && \
    mkdir -p /etc/sudoers.d && \
    echo "${user}:x:${uid}:${gid}:${user},,,:/home/${user}:/bin/bash" >> /etc/passwd && \
    echo "${user}:x:${uid}:" >> /etc/group && \
    echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${user} && \
    chmod 0440 /etc/sudoers.d/${user} && \
    chown ${uid}:${gid} -R /home/${user} && \
    apt-get update \
	&& apt-get install -y \
		wget \
        unzip \
        xauth \
        libxtst6 \
        libxi6 \
        libxrender1 \
        x11-apps \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ENV GHIDRA_FOLD $FOLD
ENV GHIDRA_VERS $VERS

RUN (wget -O ghidra.zip https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${GHIDRA_FOLD}_build/${GHIDRA_VERS}.zip \
	&& echo "$SHA256 ghidra.zip" | sha256sum -c - \
    && unzip ghidra.zip -d /opt \
    && rm ghidra.zip \
    && mv /opt/ghidra* /opt/ghidra \
    && chmod +x /opt/ghidra/ghidraRun)

ENV DISPLAY :1.0

# Run next commands as user
USER $USER

CMD /bin/bash -i -c "/opt/ghidra/support/launch.sh fg Ghidra \"2G\" \"\" ghidra.GhidraRun \"\""
