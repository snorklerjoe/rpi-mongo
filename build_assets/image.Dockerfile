ARG BASEIMG=arm64v8/mongo
ARG PLATFORM=arm64
FROM --platform=${PLATFORM} ${BASEIMG}

ADD build/bin/mongo /usr/bin/
ADD build/bin/mongod /usr/bin/
ADD build/bin/mongos /usr/bin/

ADD build/lib/* /usr/lib/

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
