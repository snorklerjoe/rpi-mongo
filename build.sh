#!/usr/bin/env bash

set -e

source inc/colors.sh

function show_help {
cat << END-OF-HELP
Usage: ./build.sh [-h/--help] TARGET OUTPUT [--reuse-builder]
Builds MongoDB from source and creates an unofficial docker image

target should be the name of a file in the current working directory.
See the existing target files for examples of how to make your own.

  TARGET                The target to build. Should be a file in ./targets/

  OUTPUT                A docker-buildkit-compatible output type
                        (local, registry, ...)

  -h, --help            Show this help message

      --reuse-builder   Reuse the buildx builder instead of pulling a new one

      --create-builder  Creates the buildx builder and exits
END-OF-HELP
}

# Argument flag check stolen from https://stackoverflow.com/questions/2875424/correct-way-to-check-for-a-command-line-flag-in-bash
[[ $* == *-h* ]] && show_help && exit

if [[ -f "${2}" ]]; then
    TARGET_CONFIG="${2}"
elif [[ -f "${1}" ]]; then
    TARGET_CONFIG="${1}"
else
    echo -e "${RED}Bud, looks like you didn't specify a valid target.${RESTORE}"
    echo -e "Run with \`--help\` to see usage instructions."
    exit 1
fi


# Because I'm wicked humble:
echo -e "${PURPLE}Unofficial MongoDB Docker Image Builder${RESTORE}"
echo -e  "${GREEN}        by ${LGREEN}Joseph R. Freeston${RESTORE}"
echo -e          "           ------ -- --------"
echo

# Load parameters from target file:
source $TARGET_CONFIG

function create_buildx {
    echo -e "${BLUE}  Running multiarch setup...${RESTORE}"
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    echo -e "${BLUE}  Creating multiplatform builder...${RESTORE}"
    BUILDER=rpi-mongo-builder
    docker buildx rm ${BUILDER} || true
    docker buildx create --name ${BUILDER} --platform ${PLATFORM}
    docker buildx use ${BUILDER}
    docker buildx inspect --bootstrap
}

function perform_build {
    docker buildx build -t snorklerjoe/rpi-mongo:${IMG_TAG} -f build_assets/image.Dockerfile $(grep -o '^[^#]*' "${TARGET_CONFIG}" | sed 's@^@--build-arg @g' | paste -s -d " ") --output type=$OUTPUT_TYPE .
}

function rm_buildx {
    echo -e "${BLUE}  Disposing of multiplatform builder...${RESTORE}"
    docker buildx rm ${BUILDER}
}


echo -e "${PURPLE}Prepping build...${RESTORE}"
[[ $* == *--reuse-builder* ]] || create_buildx;

[[ $* == *--create-builder* ]] && exit

echo -e "${PURPLE}Performing build...${RESTORE}"
perform_build;

echo -e "${PURPLE}Cleaning up...${RESTORE}"
[[ $* == *--reuse-builder* ]] || rm_buildx;
