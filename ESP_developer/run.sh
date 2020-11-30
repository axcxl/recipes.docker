#!/bin/bash

VERS=1.8.13
IMG_NAME=esp_dev

USER=dev

SERIAL=/dev/ttyUSB0

if [ "$#" -ne 1 ]; then
    echo "Parameter needed: workspace mount point"
    exit
fi

WORKSPACE=$1

if [[ "$(docker images -q $IMG_NAME:$VERS 2> /dev/null)" == "" ]]; then
    echo "BUILDING using IDE version $VERS"
    docker build -t $IMG_NAME:$VERS --build-arg VERS=$VERS --build-arg USER=$USER .

    if [[ "$?" != "0" ]]; then
        echo "BUILD FAILED!"
        exit -1
    fi
fi

echo "STARTING, workspace at $1"
docker run \
    -it \
    --rm \
    --network=host \
    --privileged \
    -e DISPLAY=$DISPLAY \
    -v $SERIAL:$SERIAL \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev:/dev \
    -v $WORKSPACE:/home/$USER/workspace \
    --name $IMG_NAME \
    $IMG_NAME:$VERS \
    arduino
