#!/bin/bash

set -e
set -u
set -o pipefail

cd $1
for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master`; do
    git branch --track ${branch##*/} $branch
done

cd -