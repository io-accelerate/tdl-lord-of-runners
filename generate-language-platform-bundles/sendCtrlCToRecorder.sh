#!/bin/bash

set -e
set -o pipefail

detectPlatform() {
	case "$(uname)" in
	  CYGWIN* )
	    echo "windows"
	    return
	    ;;
	  Darwin* )
	    echo "macos"
	    return
	    ;;
	  MINGW* )
	    echo "windows"
	    return
	    ;;
	esac
	echo "linux"
}


echo "Looking for record-and-upload.jar process"
echo "Platform: $(detectPlatform)"

if [[ "$(detectPlatform)"=="windows" ]]; then
	RECORDER_PID=$(ps -W | awk '/record_screen_and_upload.bat/,NF=1' || true)
else
	RECORDER_PID=$(jps | grep "record-and-upload.jar" | awk '{print $1}' || true)
fi

if [[ -z "${RECORDER_PID}" ]]; then
	echo "No instances of record-and-upload.jar or record_and_upload.bat running"	
	exit 0
fi
echo "Found: ${RECORDER_PID}"

echo "Sending process ${RECORDER_PID} an interruption via keyboard (Ctrl-C)"
kill -SIGINT ${RECORDER_PID}
