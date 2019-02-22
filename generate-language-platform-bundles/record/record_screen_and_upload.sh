#!/usr/bin/env bash

SCRIPT_CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

JAVA_BIN="${SCRIPT_CURRENT_DIR}/jre/bin/java"
JAR_FILE="${SCRIPT_CURRENT_DIR}/record/bin/record-and-upload.jar"
PARAM_CONFIG_FILE="${SCRIPT_CURRENT_DIR}/config/credentials.config"
PARAM_STORE_DIR="${SCRIPT_CURRENT_DIR}/record/localstore"
PARAM_SOURCECODE_DIR="${SCRIPT_CURRENT_DIR}"

ONE_GB=$((1024 * 1024))

MINIMUM_REQUIRED_DISKSPACE_HUMAN_READABLE=1
MINIMUM_REQUIRED_DISKSPACE=$((${MINIMUM_REQUIRED_DISKSPACE_HUMAN_READABLE} * ${ONE_GB}))
AVAILABLE_DISKSPACE=$(df --output=avail $HOME | tail -n 1 | awk '{print $1}')   ### Should work on both Linux and MacOS
AVAILABLE_DISKSPACE_HUMAN_READABLE=$((${AVAILABLE_DISKSPACE} / ${ONE_GB}))
echo "Available disk space on '$HOME': ${AVAILABLE_DISKSPACE_HUMAN_READABLE}GB"
echo ""
if [[ "${AVAILABLE_DISKSPACE}" -lt "${MINIMUM_REQUIRED_DISKSPACE}" ]]; then
   echo "Sorry, you need at least ${MINIMUM_REQUIRED_DISKSPACE_HUMAN_READABLE}GB of free disk space on this drive, in order to run the screen recording app (in either modes: video-enabled or video-disabled)."
   echo ""
   echo "Please make free up some disk space on '$HOME' and try running the screen recording app again."
   exit -1
fi

echo "Running using packaged JRE:"
set -ex
exec "$JAVA_BIN" -jar "$JAR_FILE" \
  "--config" "${PARAM_CONFIG_FILE}" \
  "--store" "${PARAM_STORE_DIR}" \
  "--sourcecode" "${PARAM_SOURCECODE_DIR}" "$@"
