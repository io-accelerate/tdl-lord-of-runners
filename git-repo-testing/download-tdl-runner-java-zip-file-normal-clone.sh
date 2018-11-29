#!/usr/bin/env bash

set -e
set -u
set -o pipefail

TARGET_FOLDER=normal-clone-tdl-runner-java-zip-file
rm -fr ${TARGET_FOLDER} || true

LOG_FILE=$(basename ${0})
LOG_FILE="${LOG_FILE%.*}".logs

speedtest &>> ${LOG_FILE}

time git clone \
         git@bitbucket.org:neomatrix369/tdl-runner-java-zip-file.git \
         ${TARGET_FOLDER} &>> ${LOG_FILE}

targetRepoFolderSize=$(du -s -h ${TARGET_FOLDER})
echo "Repo folder size: ${targetRepoFolderSize}" &>> ${LOG_FILE}

gitFolderSize=$(du -s -h ${TARGET_FOLDER}/.git)
echo "Git folder size: ${gitFolderSize}" &>> ${LOG_FILE}

tail ${LOG_FILE}