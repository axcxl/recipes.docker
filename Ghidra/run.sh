#!/bin/bash

IMG_NAME=ghidra
VERS=9.2_PUBLIC_20201113
SHA256=ffebd3d87bc7c6d9ae1766dd3293d1fdab3232a99b170f8ea8b57497a1704ff6

USER=dev

if [ "$#" -ne 1 ]; then
    echo "Parameter needed: workspace mount point"
    exit
fi

WORKSPACE=$1

if [[ "$(docker images -q $IMG_NAME:$VERS 2> /dev/null)" == "" ]]; then
    echo "BUILDING using IDE version $VERS"
    docker build -t $IMG_NAME:$VERS --build-arg VERS=$VERS --build-arg USER=$USER --build-arg SHA256=$SHA256 .
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

