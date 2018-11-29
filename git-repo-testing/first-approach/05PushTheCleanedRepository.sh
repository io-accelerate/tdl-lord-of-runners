#!/usr/bin/env bash

set -e
set -u
set -o pipefail

cd $1

git push origin --force --all
git push origin --force --tags

cd - 