#!/bin/bash

set -e
set -u
set -o pipefail

echo "Building the uberjar for wget"
./gradlew clean shadowJar -i

echo "Building the native-image for wget"
programName="wget"
## native-image is a part of GraalVM, the JDK for GraalVM can be downloaded from 
## Release on GitHub: https://github.com/oracle/graal/releases
## GraalVM CE 1.0 RC9: https://github.com/oracle/graal/releases/tag/vm-1.0.0-rc9
## Once downloaded and unpackaged, make JAVA_HOME point to the folder where GraalVM sits
native-image -H:-ReportUnsupportedElementsAtRuntime \
             --enable-all-security-services  \
             --enable-url-protocols=https \
             --static \
             -jar build/libs/${programName}-*-all.jar

echo "Renamed ${programName}-*-all to ${programName}"
mv ${programName}-*-all ${programName}

echo "Moved ${programName} to ../tools"
mv ${programName} ../tools
