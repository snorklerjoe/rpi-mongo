#!/usr/bin/env bash
# This is meant to be used as part of the build process by build.Dockerfile

python3 buildscripts/scons.py --ssl CC=$(dpkg -L ${CC_PACKAGE} | grep bin/ | head -1) CXX=$(dpkg -L ${CXX_PACKAGE} | grep bin/ | head -1) CCFLAGS="-march=${MARCH} -mtune=${MTUNE}" ./mongo{,s,d}
