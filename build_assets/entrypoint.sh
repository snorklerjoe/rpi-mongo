#!/bin/bash
# Copyright (c) 2023 Joseph R. Freeston
# This is part of my unnoficial mongodb Docker image builder
# Source code here: https://github.com/snorklerjoe/rpi-mongo
#
# This runs before the official MongoDB entrypoint-
# We need to do our own architecture checks and then get rid of theirs!
#

# Make sure CPUINFOGREP exists!
if [[ -z ${CPUINFOGREP+x} ]]; then
    echo -e "\033[00;31mNO ARCH SPECIFIED AT BUILD TIME!"
    echo -e "Aborting.\033[0m"
    exit 1
fi

# Default should work...
OFFICIAL_ENTRYPOINT=${OFFICIAL_ENTRYPOINT-/usr/local/bin/docker-entrypoint.sh}

# Check the architecture...
if grep -q ${CPUINFOGREP} /proc/cpuinfo; then
    echo -e "\033[00;31mWRONG ARCHITECTURE!"
    echo -e "    (Looking for ${CPUINFOGREP})"
    echo -e "Aborting.\033[0m"
    exit 1
fi

# Change the official entrypoint to not check the architecture...
# It's probably fine hehehehe...
sed -i "s/${OFF_ENTRYPT_FIND}/OFF_ENTRYPT_REPLACE/g"

# Continue with the official entrypoint:
source ${OFFICIAL_ENTRYPOINT}
# Our job here is done.
