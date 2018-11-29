#!/usr/bin/env bash

set -e
set -u
set -o pipefail

TARGET_FOLDER=shallow-clone-tdl-runner-java-expanded-folder
rm -fr ${TARGET_FOLDER} || true

LOG_FILE=$(basename ${0})
LOG_FILE="${LOG_FILE%.*}".logs

speedtest &>> ${LOG_FILE}

time git clone --depth 1 \
         git@bitbucket.org:neomatrix369/tdl-runner-java-expanded-folder.git \
         ${TARGET_FOLDER} &>> ${LOG_FILE}

du -s -h ${TARGET_FOLDER} &>> ${LOG_FILE}

tail ${LOG_FILE}