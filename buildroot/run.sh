#!/bin/bash

IMG_NAME=buildroot_dev
VERS=v1

if [ "$#" -ne 1 ]; then
    echo "Need workspace forlder to mount"
    exit
fi

dest=$1
USER=$(whoami)


if [[ "$(docker images -q $IMG_NAME:$VERS 2> /dev/null)" == "" ]]; then
    echo "BUILDING image for user $USER"
    docker build -t $IMG_NAME:$VERS --build-arg USER=$USER .
fi

docker run \
    -it \
    --rm \
    --network=host \
    --volume $1:$1 \
    --user $(id -u):$(id -g) \
    --name $IMG_NAME \
    $IMG_NAME:$VERS \
    "/bin/bash"

