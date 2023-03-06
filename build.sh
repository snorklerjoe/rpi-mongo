#!/usr/bin/env bash

source inc/colors.sh

function show_help {
cat << END-OF-HELP
Usage: ./build.sh [-h/--help] [--build-mongo] target [--skip-compile]
Builds MongoDB from source and creates an unofficial docker image

target should be the name of a file in the current working directory.
See the existing target files for examples of how to make your own.

  -h, --help            Show this help message

      --build-mongo     Compile MongoDB in a Debian docker container
                        If you're running without this option, there
                        had better be some binaries in the build/bin folder!

      --skip-compile    Skip compiling mongodb (for testing purposes)
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

if [[ $* == *--build-mongo* ]]; then
    echo -e "${PURPLE}Building MongoDB...${RESTORE}"
    if [[ ! $* == *--skip-compile* ]]; then
        echo -e "${BLUE}  Compiling/Building... ${RESTORE}"
        # Sed command stolen from https://stackoverflow.com/questions/57091385/how-to-pass-argument-to-dockerfile-from-a-file
        docker build -t snorklerjoe/rpi-mongo:build . -f build_assets/build.Dockerfile $(grep -o '^[^#]*' "${TARGET_CONFIG}" | sed 's@^@--build-arg @g' | paste -s -d " ")
    else
        echo -e "${RED}  Skipping Mongodb Compile${RESTORE}"
        echo "  (using previously-built image)"
    fi
    
    echo -e "${BLUE}  Creating container...${RESTORE}"
    docker container create --name mongo-bins snorklerjoe/rpi-mongo:build

    echo -e "${BLUE}  Extracting libraries...${RESTORE}"
    # Note: These libraries are the same as those in build.Dockerfile:
    LIB_PACKAGES="libssl-dev:${DPKG_ARCH} libcurl4-openssl-dev:${DPKG_ARCH} liblzma-dev:${DPKG_ARCH} libpcap-dev:${DPKG_ARCH}"
    LIB_SYMLINKS=$(docker run snorklerjoe/rpi-mongo:build dpkg -L ${LIB_PACKAGES} | grep .so)
    for library in ${LIB_SYMLINKS} ; do
        bin_path=$(docker run snorklerjoe/rpi-mongo:build readlink -f $library)
        echo $bin_path
        docker container cp mongo-bins:$bin_path ./build/lib/$(basename $bin_path)
    done <<< "$LIB_LOCATIONS"

    echo -e "${BLUE}  Extracting compiled binaries...${RESTORE}"
    docker container cp mongo-bins:/root/mongo/build/install/bin ./build/
    echo -e "${BLUE}  Cleaning up.${RESTORE}"
    docker container rm -f mongo-bins
fi

echo
echo -e "${PURPLE}Building Image...${RESTORE}"
echo -e "${BLUE}  Building...${RESTORE}"
DOCKER_BUILDKIT=1 docker build -t snorklerjoe/rpi-mongo:${IMG_TAG} . -f build_assets/image.Dockerfile $(grep -o '^[^#]*' "${TARGET_CONFIG}" | sed 's@^@--build-arg @g' | paste -s -d " ")

