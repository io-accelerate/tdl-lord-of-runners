#!/usr/bin/env bash

set -e

SCRIPT_CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SELF_VERSION=$(cat "${SCRIPT_CURRENT_DIR}/version.self.txt")

# Prepare output dir
BUILD_DIR="${SCRIPT_CURRENT_DIR}/build/v${SELF_VERSION}"
mkdir -p "${BUILD_DIR}"

# Prepare working directory
WORK_DIR="${SCRIPT_CURRENT_DIR}/work"
rm -Rf "${WORK_DIR}"
mkdir -p "${WORK_DIR}"
RUNNER_DIR="${WORK_DIR}/accelerate_runner"

# Read input
if [ $# -ne 2 ]; then
  echo "Syntax is: $0 language platform"
  exit 1
fi
TARGET_LANGUAGE="$1"
TARGET_PLATFORM="$2"

# 1. Get Runner
RUNNER_VERSION=$(cat "${SCRIPT_CURRENT_DIR}/version.runner.${TARGET_LANGUAGE}.txt")
REMOTE_RUNNER_ZIP="https://github.com/julianghionoiu/tdl-runner-${TARGET_LANGUAGE}/archive/v${RUNNER_VERSION}.zip"
echo "Download the language runner from ${REMOTE_RUNNER_ZIP}"
"${SCRIPT_CURRENT_DIR}/download.sh" "${REMOTE_RUNNER_ZIP}" "${WORK_DIR}/runner.zip"
unzip "${WORK_DIR}/runner.zip" -d "${WORK_DIR}/."
mv "${WORK_DIR}/tdl-runner-${TARGET_LANGUAGE}-${RUNNER_VERSION}" "${RUNNER_DIR}"

# 2. Get JRE
JRE_VERSION=$(cat "${SCRIPT_CURRENT_DIR}/version.jre.txt")
REMOTE_JRE_ZIP="https://s3.eu-west-2.amazonaws.com/jre.download/jre8/minimised/${JRE_VERSION}-${TARGET_PLATFORM}-x64-minimal.zip"
"${SCRIPT_CURRENT_DIR}/download.sh" "${REMOTE_JRE_ZIP}" "${WORK_DIR}/jre.zip"
unzip "${WORK_DIR}/jre.zip" -d "${RUNNER_DIR}/jre"

# 3. Get Recording JAR
RECORDER_VERSION=$(cat "${SCRIPT_CURRENT_DIR}/version.recorder.txt")
REMOTE_RECORDER_JAR="https://github.com/julianghionoiu/record-and-upload/releases/download/v${RECORDER_VERSION}/record-and-upload-${TARGET_PLATFORM}-${RECORDER_VERSION}-all.jar"
mkdir -p  "${RUNNER_DIR}/record/bin"
"${SCRIPT_CURRENT_DIR}/download.sh" "${REMOTE_RECORDER_JAR}" "${RUNNER_DIR}/record/bin/record-and-upload.jar"

# 4. Place Recording script
rm -f "${RUNNER_DIR}/record_and_upload.sh"
rm -f "${RUNNER_DIR}/record_and_upload.bat"
FILE_EXT="sh"
if [ "${TARGET_PLATFORM}" == "windows" ]; then
   FILE_EXT="bat"
fi		
LOCAL_RECORDER_SCRIPT="${SCRIPT_CURRENT_DIR}/record/record_and_upload.${FILE_EXT}"
echo "cp ${LOCAL_RECORDER_SCRIPT} ${RUNNER_DIR}/record_and_upload.${FILE_EXT}"
cp "${LOCAL_RECORDER_SCRIPT}" "${RUNNER_DIR}/record_and_upload.${FILE_EXT}"

# 5. Bundle
BUNDLE_ZIP_NAME="runner-for-${TARGET_LANGUAGE}-${TARGET_PLATFORM}.zip"
BUNDLE_ZIP_FILE="${BUILD_DIR}/${BUNDLE_ZIP_NAME}"
BUNDLE_ZIP_MANIFEST="${BUILD_DIR}/${BUNDLE_ZIP_NAME}.meta"
rm -f "${BUNDLE_ZIP_FILE}"
(cd "${WORK_DIR}" && zip "${BUNDLE_ZIP_FILE}" -r "./accelerate_runner")
cat > "${BUNDLE_ZIP_MANIFEST}" <<End-of-message
RUNNER_VERSION=${RUNNER_VERSION}
JRE_VERSION=${JRE_VERSION}
RECORDER_VERSION=${RECORDER_VERSION}
End-of-message

# Wrap it up
cat "${BUNDLE_ZIP_MANIFEST}"
echo "Created ${BUNDLE_ZIP_FILE}"