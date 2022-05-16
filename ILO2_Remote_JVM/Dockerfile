FROM sgrio/java:jre_8_ubuntu

ARG PALEMOON

RUN apt-get update \
	&& apt-get install -y \
        wget xz-utils   \
        libfreetype6    \
        libfontconfig1  \
        libxrender1     \
        libasound2      \
        libdbus-glib-1-2 \
        libgtk2.0-0     \
        libx11-xcb1     \
        libxt6          \
        libxtst6        \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
    && sed -i 's/MD5\,//g' /usr/lib/jvm/java-8-oracle/lib/security/java.security \
    && mkdir -p /usr/lib/mozilla/plugins \
    && ln -s /usr/lib/jvm/java-8-oracle/lib/amd64/libnpjp2.so /usr/lib/mozilla/plugins/libnpjp2.so \
    && wget $PALEMOON -O palemoon.tar.xz \
    && tar xvf palemoon.tar.xz

RUN mkdir -p /root/palemoon_profile

ADD user.js /root/palemoon_profile

RUN mkdir -p /root/.java/deployment/security \
    && echo "http://$IP" >> /root/.java/deployment/security/exception.sites \
    && echo "https://$IP" >> /root/.java/deployment/security/exception.sites
