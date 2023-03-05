ARG BASEIMG=arm64v8/mongo
ARG PLATFORM=arm64
FROM --platform=${PLATFORM} ${BASEIMG}

ADD build/bin/mongo /bin/
ADD build/bin/mongod /bin/
ADD build/bin/mongos /bin/

# From HiFiGuitarGuy's comment here: https://andyfelong.com/2021/08/mongodb-4-4-under-raspberry-pi-os-64-bit-raspbian64/#comments
RUN sed -i 's/fphp|dcpop|sha3|sm3|sm4|asimddp|sha512|sve/fp|dcpop|sha3|sm3|sm4|asimddp|sha512|sve/g' /usr/local/bin/docker-entrypoint.sh
