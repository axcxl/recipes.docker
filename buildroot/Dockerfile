FROM ubuntu:18.04

ARG USER

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    sudo \
    build-essential \
    bc \
    make \
    libncurses-dev \
    file \
    git \
    wget \
    cpio \
    unzip \
    python3 \
    rsync


RUN export uid=1000 gid=1000 user=$USER && \
    mkdir -p /home/$USER && \
    mkdir -p /etc/sudoers.d && \
    echo "${user}:x:${uid}:${gid}:${user},,,:/home/${user}:/bin/bash" >> /etc/passwd && \
    echo "${user}:x:${uid}:" >> /etc/group && \
    echo "${user} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${user} && \
    chmod 0440 /etc/sudoers.d/${user} && \
    chown ${uid}:${gid} -R /home/${user} && \
        apt-get clean \
        && rm -rf /var/lib/apt/lists/*

