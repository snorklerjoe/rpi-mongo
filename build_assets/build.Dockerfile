#FROM debian:11.6-slim AS mongo-build
FROM ubuntu:jammy AS mongo-build

# Defaults to compile for pi
ARG MONGO_RELEASE=v4.4
ARG CC_PACKAGE=gcc-aarch64-linux-gnu
ARG CXX_PACKAGE=g++-aarch64-linux-gnu

WORKDIR /root/

# Install build dependencies:
RUN apt-get update && apt-get install -y wget libcurl4-openssl-dev python3 python3-pip git ${CC_PACKAGE} ${CXX_PACKAGE}

ARG DPKG_ARCH=arm64
ARG MARCH=armv8-a+crc
ARG MTUNE=cortex-a72
ARG LIB_APT_SOURCE=http://raspbian.raspberrypi.org/raspbian/
ARG LIB_APT_DIST=bullseye
ARG LIB_PACKAGES=bullseye
ARG LIB_APT_COMPONENTS="main rpi"

RUN dpkg --add-architecture ${DPKG_ARCH}
RUN cat /etc/apt/sources.list > /etc/apt/sources.list.bak && \
    sed -i 's/archive.ubuntu.com\/ubuntu/ports.ubuntu.com\/ubuntu-ports/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com\/ubuntu/ports.ubuntu.com\/ubuntu-ports/g' /etc/apt/sources.list && \
    cat /etc/apt/sources.list.bak >> /etc/apt/sources.list && grep -o '^[^#]*' /etc/apt/sources.list

#    sed -i '/.*amd64.*/d' /etc/apt/sources.list
RUN apt-get update
ARG LIB_APT_DEBIAN=
RUN apt-get install -y ${LIB_APT_DEBIAN}
#RUN echo deb [arch=${DPKG_ARCH}] ${LIB_APT_SOURCE} ${LIB_APT_DIST} ${LIB_APT_COMPONENTS} > /etc/apt/sources.list
#ARG LIB_APT_PRE_CMD
#RUN ${LIB_APT_PRE_CMD}
#RUN apt-get update && apt-get install -t ${LIB_APT_DIST} -y ${LIB_PACKAGES}
RUN apt-get install -y ${LIB_PACKAGES}

# Clone Mongo source:
RUN git clone https://github.com/mongodb/mongo -b ${MONGO_RELEASE} --single-branch
WORKDIR /root/mongo/

# Compile Mongo:
RUN python3 -m pip install --user -r etc/pip/compile-requirements.txt

ADD build_assets/compile_mongo.sh /root/mongo/
RUN MARCH=${MARCH} MTUNE=${MTUNE} CC_PACKAGE=${CC_PACKAGE} CXX_PACKAGE=${CXX_PACKAGE} bash ./compile_mongo.sh

CMD [ "bash" ]
