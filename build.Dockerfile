FROM debian:11.6-slim AS mongo-build

# Defaults to compile for pi
ARG MONGO_RELEASE=v4.4
ARG CC_PACKAGE=gcc-aarch64-linux-gnu
ARG CXX_PACKAGE=g++-aarch64-linux-gnu
ARG DPKG_ARCH=arm64
ARG MARCH=armv8-a+crc
ARG MTUNE=cortex-a72

WORKDIR /root/

# Install build dependencies:
RUN apt-get update
RUN apt-get install -y libcurl4-openssl-dev python3 python3-pip git ${CC_PACKAGE} ${CXX_PACKAGE}
RUN dpkg --add-architecture ${DPKG_ARCH}
RUN apt-get update
RUN apt-get install -y libssl-dev:${DPKG_ARCH} libcurl4-openssl-dev:${DPKG_ARCH} liblzma-dev:${DPKG_ARCH} libpcap-dev:${DPKG_ARCH}

# Clone Mongo source:
RUN git clone https://github.com/mongodb/mongo -b ${MONGO_RELEASE} --single-branch
WORKDIR /root/mongo/

# Compile Mongo:
RUN python3 -m pip install --user -r etc/pip/compile-requirements.txt

ADD build_assets/compile_mongo.sh /root/mongo/
RUN CC_PACKAGE=${CC_PACKAGE} CXX_PACKAGE=${CXX_PACKAGE} bash ./compile_mongo.sh

CMD [ "bash" ]
