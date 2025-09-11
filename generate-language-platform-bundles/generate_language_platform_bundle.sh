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
if [ $# -ne 3 ]; then
  echo "Syntax is: $0 language platform architecture"
  exit 1
fi
TARGET_LANGUAGE="$1"
TARGET_PLATFORM="$2"
TARGET_ARCH="$3"

# 1. Get Runner
RUNNER_VERSION=$(cat "${SCRIPT_CURRENT_DIR}/version.runner.${TARGET_LANGUAGE}.txt")
REMOTE_RUNNER_ZIP="https://github.com/io-accelerate/tdl-runner-${TARGET_LANGUAGE}/archive/v${RUNNER_VERSION}.zip"
echo "Download the language runner from ${REMOTE_RUNNER_ZIP}"
"${SCRIPT_CURRENT_DIR}/download.sh" "${REMOTE_RUNNER_ZIP}" "${WORK_DIR}/runner.zip"
unzip "${WORK_DIR}/runner.zip" -d "${WORK_DIR}/."
mv "${WORK_DIR}/tdl-runner-${TARGET_LANGUAGE}-${RUNNER_VERSION}" "${RUNNER_DIR}"

# 2. Get JDK
JDK_VERSION=$(cat "${SCRIPT_CURRENT_DIR}/version.jdk.txt")
REMOTE_JRE_ZIP="https://s3.eu-west-2.amazonaws.com/jre.download/jdk21/minimised/${JDK_VERSION}-${TARGET_PLATFORM}-${TARGET_ARCH}-minimal.zip"
"${SCRIPT_CURRENT_DIR}/download.sh" "${REMOTE_JRE_ZIP}" "${WORK_DIR}/jdk.zip"
mkdir -p "${RUNNER_DIR}/track"
unzip "${WORK_DIR}/jdk.zip" -d "${RUNNER_DIR}/track"

# 3. Get Track Code JAR
TRACK_CODE_AND_UPLOAD_VERSION=$(cat "${SCRIPT_CURRENT_DIR}/version.track_code_and_upload.txt")
REMOTE_TRACK_CODE_AND_UPLOAD_VERSION="https://github.com/io-accelerate/trk-track-code-and-upload/releases/download/v${TRACK_CODE_AND_UPLOAD_VERSION}/track-code-and-upload-${TRACK_CODE_AND_UPLOAD_VERSION}-all.jar"
mkdir -p  "${RUNNER_DIR}/track/jar"
"${SCRIPT_CURRENT_DIR}/download.sh" "${REMOTE_TRACK_CODE_AND_UPLOAD_VERSION}" "${RUNNER_DIR}/track/jar/track-code-and-upload.jar"

# 4. Place the Track Code and Upload scripts
rm -f "${RUNNER_DIR}/track_code_and_upload.sh"	
rm -f "${RUNNER_DIR}/track_code_and_upload.sh"
cp "${SCRIPT_CURRENT_DIR}/resources/track_code_and_upload.sh" "${RUNNER_DIR}/track_code_and_upload.sh"
cp "${SCRIPT_CURRENT_DIR}/resources/track_code_and_upload.bat" "${RUNNER_DIR}/track_code_and_upload.bat"

# 5. Ensure that the "track" folder is ignored in .gitignore
if ! grep -q "^track/$" "${RUNNER_DIR}/.gitignore"; then
  echo >> "${RUNNER_DIR}/.gitignore"
  echo "track/" >> "${RUNNER_DIR}/.gitignore"
fi

# 6. Create the user config and challenges folders
mkdir -p "${RUNNER_DIR}/challenges"
cp "${SCRIPT_CURRENT_DIR}/resources/challenges/README.md" "${RUNNER_DIR}/challenges/README.md"
mkdir -p "${RUNNER_DIR}/config"
cp "${SCRIPT_CURRENT_DIR}/resources/config/credentials.config.lives.here" "${RUNNER_DIR}/config/credentials.config.lives.here"

# 7. Bundle
BUNDLE_ZIP_NAME="runner-for-${TARGET_LANGUAGE}-${TARGET_PLATFORM}-${TARGET_ARCH}.zip"
BUNDLE_ZIP_FILE="${BUILD_DIR}/${BUNDLE_ZIP_NAME}"
BUNDLE_ZIP_MANIFEST="${BUILD_DIR}/${BUNDLE_ZIP_NAME}.meta"
rm -f "${BUNDLE_ZIP_FILE}"
(cd "${WORK_DIR}" && zip "${BUNDLE_ZIP_FILE}" -r "./accelerate_runner")
cat > "${BUNDLE_ZIP_MANIFEST}" <<End-of-message
RUNNER_VERSION=${RUNNER_VERSION}
JDK_VERSION=${JDK_VERSION}
TRACK_CODE_AND_UPLOAD_VERSION=${TRACK_CODE_AND_UPLOAD_VERSION}
End-of-message

# Wrap it up
cat "${BUNDLE_ZIP_MANIFEST}"
echo "Created ${BUNDLE_ZIP_FILE}"