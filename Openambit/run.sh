# WARNING: WIP
#!/bin/bash

IMG_NAME=openambit
VERS=v1

if [ "$#" -ne 1 ]; then
    echo "Need folder to use for log download"
    exit
fi

dest=$1
USER=$(whoami)

cp $(pwd)/openambit.conf $dest/

if [[ "$(docker images -q $IMG_NAME:$VERS 2> /dev/null)" == "" ]]; then
    echo "BUILDING image for user $USER"
    docker build -t $IMG_NAME:$VERS --build-arg USER=$USER .
fi

docker run \
    -it \
    --rm \
    --network=host \
    --privileged \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume /dev:/dev \
    --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
    --volume /etc/passwd:/etc/passwd:ro \
    --volume /etc/group:/etc/group:ro \
    --volume $dest:/home/$(whoami)/.openambit \
    --user $(id -u):$(id -g) \
    --name $IMG_NAME \
    $IMG_NAME:$VERS \
    "/bin/bash"

