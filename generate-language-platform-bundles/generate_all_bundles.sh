#!/usr/bin/env bash

set -xe

SCRIPT_CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

AVAILABLE_LANGUAGES="java scala kotlin python ruby nodejs csharp fsharp vbnet"
for LANGUAGE in ${AVAILABLE_LANGUAGES}; do
    echo "~~~~~~~~~~~~ Generating bundles for ${LANGUAGE} ~~~~~~~~~~~"
    ${SCRIPT_CURRENT_DIR}/generate_language_platform_bundle.sh ${LANGUAGE} macos x64
    ${SCRIPT_CURRENT_DIR}/generate_language_platform_bundle.sh ${LANGUAGE} macos aarch64
    
    ${SCRIPT_CURRENT_DIR}/generate_language_platform_bundle.sh ${LANGUAGE} linux x64
    ${SCRIPT_CURRENT_DIR}/generate_language_platform_bundle.sh ${LANGUAGE} linux aarch64
    
    ${SCRIPT_CURRENT_DIR}/generate_language_platform_bundle.sh ${LANGUAGE} windows x64
    ${SCRIPT_CURRENT_DIR}/generate_language_platform_bundle.sh ${LANGUAGE} windows aarch64
done