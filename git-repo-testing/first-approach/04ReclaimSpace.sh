#!/usr/bin/env bash

set -e
set -u
set -o pipefail

cd $1

rm -rf .git/refs/original/

git reflog expire --expire=now --all

git reflog expire --expire-unreachable=now --all

git gc --prune=now

git gc --aggressive --prune=now

cd -