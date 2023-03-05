#!/usr/bin/env bash

source inc/colors.sh

echo -e "${PURPLE}Building MongoDB${RESTORE}"
docker build -t snorklerjoe/rpi-mongo:build . -f build.Dockerfile
#docker container create --name extract snorklerjoe/rpi-mongo:build

#docker container cp extract:/path/to/mongo/once/built ./app  
#docker container rm -f extract


