#!/bin/bash

set -e
set -u
set -o pipefail

run() {
	rm befaster.tgz || true

	echo "Tarring individual folders"
	./tar-folder.sh tdl-runner-java
	./tar-folder.sh record record-and-upload
	
	echo "Concatenating tar files"
	cp record-and-upload.tar befaster.tar
	tar --concatenate --file befaster.tar tdl-runner-java.tar

	rm tdl-runner-java.tar record-and-upload.tar || true

	echo "Compressing tar file"
	gzip -f -9 befaster.tar && mv befaster.tar.gz befaster.tgz
	tar --verbose --list --auto-compress --ignore-zeros --file befaster.tgz
	#
	# tar --verbose --extract --auto-compress --ignore-zeros --file befaster.tgz
}

time run