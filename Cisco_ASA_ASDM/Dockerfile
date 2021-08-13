FROM ubuntu:16.04

# Install everything needed

# The sed is needed to allow the algorithm required, MD5,
# otherwise you get a "Cannot grant permissions to unsigned jars" error when trying to run the jar
RUN apt-get update \
	&& apt-get install -y \
        icedtea-plugin \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
    && sed -i 's/MD5\,//g' /etc/java-8-openjdk/security/java.security
