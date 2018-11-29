#!/bin/bash

set -e
set -u
set -o pipefail

TARGET_FOLDER=$1
TARGET_TGZ=${2:-${TARGET_FOLDER}}

tar -cvf ${TARGET_TGZ}.tar ${TARGET_FOLDER}