#!/bin/bash

set -e
set -u
set -o pipefail

echo "Building the uberjar for wget"
./gradlew clean shadowJar -i

echo "Building the native-image for wget"
programName="wget"
native-image -H:-ReportUnsupportedElementsAtRuntime \
             --enable-all-security-services  \
             --enable-url-protocols=https \
             --static \
             -jar build/libs/${programName}-*-all.jar

echo "Renamed ${programName}-*-all to ${programName}"
mv ${programName}-*-all ${programName}

echo "Moved ${programName} to ../tools"
mv ${programName} ../tools
