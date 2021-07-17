#!/bin/bash

IMG_NAME=ghidra
VERS=ghidra_10.0.1_PUBLIC_20210708
tmp=${VERS#*_}
FOLD=${tmp%%_*}
SHA256=9b68398fcc4c2254a3f8ff231c4e8b2ac75cc8105f819548c7eed3997f8c5a5d

USER=dev

if [ "$#" -ne 1 ]; then
    echo "Parameter needed: workspace mount point"
    exit
fi

WORKSPACE=$1

if [[ "$(docker images -q $IMG_NAME:$VERS 2> /dev/null)" == "" ]]; then
    echo "BUILDING using IDE version $VERS from folder $FOLD"
    docker build -t $IMG_NAME:$VERS --build-arg VERS=$VERS --build-arg USER=$USER --build-arg SHA256=$SHA256 --build-arg FOLD=$FOLD .
fi

echo "STARTING, workspace at $1"
docker run \
    -it \
    --rm \
    --network=host \
    --privileged \
    --shm-size=2G \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev:/dev \
    -v $WORKSPACE:/home/$USER/workspace \
    --name $IMG_NAME \
    $IMG_NAME:$VERS

