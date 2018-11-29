#!/bin/bash

set -e
set -u
set -o pipefail

currentDirectory=$(pwd)

RECORD_ZIP="record-and-upload.zip"
TARGET_REPO="tdl-runner-java"
TARGET_REPO_ZIP="tdl-runner-java"

cd ..

cd ${TARGET_REPO}
gitUrl=$(git remote get-url origin)

du -s -h
rm -fr .git

git init
git remote add origin ${gitUrl}
git remote -v

du -s -h

cd ..

zip -r ${TARGET_REPO_ZIP}.zip ${TARGET_REPO}

du -h ${TARGET_REPO_ZIP}.zip

zipmerge merged-befaster.zip ${TARGET_REPO_ZIP}.zip ${RECORD_ZIP}

du -h merged-befaster.zip

mv merged-befaster.zip ${currentDirectory}

cd ${currentDirectory}