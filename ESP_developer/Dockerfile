# Based on https://github.com/tombenke/darduino
# Added automatic install of ESP and some sensor libraries
# Moved user and IDE vers to arguments for easy update
FROM ubuntu:16.04

ARG VERS
ARG USER

ENV HOME /home/$USER
WORKDIR /home/$USER

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 user=$USER && \
    mkdir -p /home/$USER && \
    echo "${user}:x:${uid}:${gid}:${user},,,:/home/${user}:/bin/bash" >> /etc/passwd && \
    echo "${user}:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/${user} && \
    apt-get update \
	&& apt-get install -y \
        software-properties-common \
		wget \
		openjdk-9-jre \
		xvfb \
        xz-utils \
        avrdude \
        avrdude-doc \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Add user to the dialout group to be ale to write the serial USB device
RUN sed "s/^dialout.*/&$USER/" /etc/group -i \
    && sed "s/^root.*/&$USER/" /etc/group -i

ENV ARDUINO_IDE_VERSION $VERS
RUN (wget -q -O- https://downloads.arduino.cc/arduino-${ARDUINO_IDE_VERSION}-linux64.tar.xz \
	| tar xJC /usr/local/share \
	&& ln -s /usr/local/share/arduino-${ARDUINO_IDE_VERSION} /usr/local/share/arduino \
	&& ln -s /usr/local/share/arduino-${ARDUINO_IDE_VERSION}/arduino /usr/local/bin/arduino)

ENV DISPLAY :1.0

# Run next commands as user
USER $USER

# Install in Adruino IDE:
# - ESP8266 and ESP32 boards
# - some sensor libraries
# - DQTT and PubSubClient libraries
RUN (arduino --pref "boardsmanager.additional.urls=https://dl.espressif.com/dl/package_esp32_index.json,http://arduino.esp8266.com/stable/package_esp8266com_index.json" --save-prefs \
        && arduino --install-boards esp32:esp32 --save-prefs \
        && arduino --install-boards esp8266:esp8266 --save-prefs \ 
        && arduino --install-library "ArduinoJson" \
        && arduino --install-library "Adafruit Unified Sensor" \
        && arduino --install-library "Adafruit BMP280 Library" \
        && arduino --install-library "DHT sensor library" \ 
        && arduino --install-library "M5Stack" \
        && arduino --install-library "MQTT" \
        && arduino --install-library "NTPClient"  \
        && arduino --install-library "PubSubClient" )
