#!/bin/bash
#
# REQUIRES MANAGEMENT ACCESS CONFIGURED AND HTTP SERVER ENABLED!
# Needs to be run with ip as parameter! E.g.: ./run.sh 192.168.1.56
#
# Idea on how to run without browser came from here:
# https://community.cisco.com/t5/network-security/asdm-on-ubuntu/td-p/3067651
#
#To set the management interface IP:
#- connect via serial (either USB ttyACM interface or console port)
#- go to configure mode: configure terminal
#- enable http access: http <network/ip> <netmask> management
#- enable http server: http server enable
#- select mgmt interface: interface management 1/1
#- add ip: ip address <ip> <netmask>

IMG_NAME=cisco_asa
VERS=v1

if [ "$#" -ne 1 ]; then
    echo "Parameter needed: IP of device"
    exit
fi

IP=$1

if [[ "$(docker images -q $IMG_NAME:$VERS 2> /dev/null)" == "" ]]; then
    docker build -t $IMG_NAME:$VERS .
fi

echo "Connecting to IP: $IP"
echo "Please check 'Always trust' and allow everything when prompted!!"

docker run \
    -it \
    --rm \
    --network=host \
    --env="DISPLAY" \
    --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
    --name $IMG_NAME \
    $IMG_NAME:$VERS \
    bin/bash -i -c "javaws https://$IP/admin/public/asdm.jnlp"

