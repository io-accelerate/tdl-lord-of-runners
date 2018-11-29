#!/usr/bin/env bash

set -e
set -u
set -o pipefail

TARGET_ZIP=merged-befaster.zip
rm -f ${TARGET_ZIP} || true

LOG_FILE=$(basename ${0})
LOG_FILE="${LOG_FILE%.*}".logs

speedtest &>> ${LOG_FILE}

DOWNLOAD_LOCATION="https://[s3-region].amazonaws.com/[bucket-name]"
time wget ${DOWNLOAD_LOCATION}/${TARGET_ZIP}

gitFolderSize=$(du -s -h ${TARGET_ZIP})
echo "File size: ${gitFolderSize}" &>> ${LOG_FILE}

tail ${LOG_FILE}