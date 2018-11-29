#!/bin/bash

set -e
set -u
set -o pipefail

WORKING_DIR=befaster

run() {
	mkdir ${WORKING_DIR}
	for x in *.zip ; do unzip -d ${WORKING_DIR} -o -u $x ; done
	cd ${WORKING_DIR}
	zip -r ../befaster.zip .
	cd ..
	rm -fr ${WORKING_DIR}
}

time run