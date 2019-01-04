#!/usr/bin/env bash

set -e

SCRIPT_CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="${SCRIPT_CURRENT_DIR}/.cache"
mkdir -p ${CACHE_DIR}

SOURCE_URL="$1"
DESTINATION_FILE="$2"

FILE_NAME=$(echo ${SOURCE_URL}| rev | cut -d "/" -f1 | rev)
URL_HASH=$(echo ${SOURCE_URL} | shasum | tr -d " -")
CACHED_FILE="${CACHE_DIR}/${FILE_NAME}---${URL_HASH}"

if [ -f "${CACHED_FILE}" ]; then
    echo "File already exists in local cache: ${CACHED_FILE}"
else
    echo "Downloading to ${CACHED_FILE}"
    curl -L -o "${CACHED_FILE}" "${SOURCE_URL}"
fi

echo "Copying to ${DESTINATION_FILE}"
cp "${CACHED_FILE}" "${DESTINATION_FILE}"

