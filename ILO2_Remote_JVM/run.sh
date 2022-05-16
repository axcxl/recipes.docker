#!/bin/bash
#

IMG_NAME=ilo2
VERS=v1
PALEMOON=http://linux.palemoon.org/datastore/release/palemoon-31.0.0.linux-x86_64-gtk2.tar.xz

if [ "$#" -ne 1 ]; then
    echo "Parameter needed: IP of device"
    exit
fi

IP=$1

if [[ "$(docker images -q $IMG_NAME:$VERS 2> /dev/null)" == "" ]]; then
    docker build -t $IMG_NAME:$VERS --build-arg PALEMOON=$PALEMOON .
fi

echo -e "\n\n"
echo "Connecting to IP: $IP"
echo "WARNING! Make sure you connect to a trusted host! To run the ILO most of the JAVA security is disabled!"
echo -e "\n"
echo "Because of security stuff, you need to manually allow a lot of things to get JAVA working:"
echo "1. When loading the site, you will get \"Connection is untrusted\" -> I Understand the risks -> Add exception -> Confirm exception"
echo "<< Login, go to the \"Remote Console\" tab and start the \"Remote console\" >>"
echo "2. Your Java version is out of date -> LATER"
echo "3. The connection to this website is untrusted -> check address is $IP:443 -> CONTINUE"
echo "4. You will get a \"Error. Click for details\" in the new window. Click on it, then click on Reload"
echo "5. You should see a new warning \"Do you want to run this application?\". Confirm it says:"
echo -e "\t\"Name: remcons\""
echo -e "\t\"Location: https://$IP\""
echo -e "\tThen check the box below and click Run"
echo "6. Another security warning will appear, check the web site address is as above, check the do not show box and click Allow"
echo -e "\n\n"
echo "Press any key to start"

read -n1 


docker run \
    -it \
    --rm \
    --network=host \
    --env="DISPLAY" \
    --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
    --name $IMG_NAME \
    $IMG_NAME:$VERS \
    bin/bash -c "echo \"http://$IP\" >> /root/.java/deployment/security/exception.sites \
    && echo \"https://$IP\" >> /root/.java/deployment/security/exception.sites \
    && /palemoon/palemoon --profile /root/palemoon_profile https://$IP"

