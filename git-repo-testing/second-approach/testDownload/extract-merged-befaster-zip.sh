#!/usr/bin/env bash

set -e
set -u
set -o pipefail

LOG_FILE=$(basename ${0})
LOG_FILE="${LOG_FILE%.*}".logs

time unzip merged-befaster.zip &>> ${LOG_FILE}

SIZE_OF_REPO=$(du -s -h tdl-runner-java)
SIZE_OF_RECORD=$(du -s -h record)

echo "${SIZE_OF_REPO}" &>> ${LOG_FILE}
echo "${SIZE_OF_RECORD}" &>> ${LOG_FILE}