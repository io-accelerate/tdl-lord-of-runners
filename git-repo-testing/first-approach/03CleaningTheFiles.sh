#!/bin/bash

set -e
set -u
set -o pipefail

cd $1

echo "Removing all branches except master"
(git branch --merged | egrep -v "(^\*|master|dev)" | git push --delete origin ) || true
(git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d ) || true

git filter-branch \
    --tag-name-filter cat \
    --index-filter 'git rm -r --cached --ignore-unmatch filename' \
    --prune-empty -f -- --all

cd -