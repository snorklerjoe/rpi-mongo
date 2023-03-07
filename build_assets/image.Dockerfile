ARG BASEIMG=arm64v8/mongo
ARG PLATFORM=arm64
FROM --platform=${PLATFORM} ${BASEIMG}


# Prepare
#########
ARG CC_PACKAGE=gcc-aarch64-linux-gnu
ARG CXX_PACKAGE=g++-aarch64-linux-gnu
ARG DPKG_ARCH
RUN dpkg --add-architecture ${DPKG_ARCH}
RUN apt-get update && apt-get install -y git python3 python3-pip ${CC_PACKAGE} ${CXX_PACKAGE}

# Grab mongo & Attempt to compile:
##################################
ARG MONGO_RELEASE=v4.4
WORKDIR /root
RUN git clone https://github.com/mongodb/mongo -b ${MONGO_RELEASE} --single-branch
WORKDIR /root/mongo/

# Install build requirements:
RUN python3 -m pip install --user -r etc/pip/compile-requirements.txt

ARG MARCH=armv8-a+crc
ARG MTUNE=cortex-a72

RUN apt-get install -y libssl-dev:${DPKG_ARCH} libcurl4-openssl-dev:${DPKG_ARCH} liblzma-dev:${DPKG_ARCH} libpcap-dev:${DPKG_ARCH}


ADD build_assets/compile_mongo.sh /root/mongo/
RUN MARCH=${MARCH} MTUNE=${MTUNE} CC_PACKAGE=${CC_PACKAGE} CXX_PACKAGE=${CXX_PACKAGE} bash ./compile_mongo.sh


# Finish it off:
################

# The new entrypoint:
ARG CPUINFOGREP
ENV CPUINFOGREP=${CPUINFOGREP}

ARG OFF_ENTRYPT_FIND
ENV OFF_ENTRYPT_FIND=${OFF_ENTRYPT_FIND}

ARG OFF_ENTRYPT_REPLACE
ENV OFF_ENTRYPT_REPLACE=${OFF_ENTRYPT_REPLACE}

ADD build_assets/entrypoint.sh /better_entrypoint.sh

ENTRYPOINT [ "/better_entrypoint.sh" ]
CMD [ "/usr/bin/mongod" ]  # Copied from the base image
