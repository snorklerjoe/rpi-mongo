#!/usr/bin/env bash

source inc/colors.sh

function show_help {
cat << END-OF-HELP
Usage: ./build.sh [-h/--help] [--build-mongo target]
Builds MongoDB from source and creates an unofficial docker image

target should be the name of a file in the current working directory.
See the existing target files for examples of how to make your own.

  -h, --help            Show this help message
      --build-mongo     Compile MongoDB in a Debian docker container
                        Provide a target file. See the examples given.
                        If you're running without this option, there
                        had better be some binaries in the build/bin folder!
END-OF-HELP
}

# Because I'm wicked humble:
echo -e "${PURPLE}Unofficial MongoDB Docker Image Builder${RESTORE}"
echo -e  "${GREEN}        by ${LGREEN}Joseph R. Freeston${RESTORE}"
echo -e          "           ------ -- --------"
echo

# Argument flag check stolen from https://stackoverflow.com/questions/2875424/correct-way-to-check-for-a-command-line-flag-in-bash
[[ $* == *-h* ]] && show_help && exit

if [[ $* == *--build-mongo* ]]; then
    echo -e "${PURPLE}Building MongoDB...${RESTORE}"
    # Sed command stolen from https://stackoverflow.com/questions/57091385/how-to-pass-argument-to-dockerfile-from-a-file
    docker build -t snorklerjoe/rpi-mongo:build . -f build.Dockerfile $(cat $2 | sed 's@^@--build-arg @g' | paste -s -d " ")
    docker container create --name mongo-bins snorklerjoe/rpi-mongo:build
    docker container cp mongo-bins:/root/mongo/build/install/bin ./build/
    docker container rm -f mongo-bins
fi

echo -e "${PURPLE}Building Image...${RESTORE}"


