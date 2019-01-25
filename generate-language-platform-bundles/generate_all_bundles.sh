#!/usr/bin/env bash

set -xe

SCRIPT_CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

AVAILABLE_LANGUAGES="java scala python ruby csharp fsharp vbnet"
for LANGUAGE in ${AVAILABLE_LANGUAGES}; do
    echo "~~~~~~~~~~~~ Generating bundles for ${LANGUAGE} ~~~~~~~~~~~"
    ${SCRIPT_CURRENT_DIR}/generate_language_platform_bundle.sh ${LANGUAGE} macos
    ${SCRIPT_CURRENT_DIR}/generate_language_platform_bundle.sh ${LANGUAGE} linux
    ${SCRIPT_CURRENT_DIR}/generate_language_platform_bundle.sh ${LANGUAGE} windows
done