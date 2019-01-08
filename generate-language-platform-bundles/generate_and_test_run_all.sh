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

DETECTED_PLATFORM=$(detectPlatform)
AVAILABLE_LANGUAGES="java scala python ruby csharp fsharp vbnet"

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
if [[ -z "${TARGET_PLATFORM}" ]]; then
	echo "No user-specified platform supplied, detected platform: ${DETECTED_PLATFORM}" 1>&2
else 
	echo "User-specified platform: ${TARGET_PLATFORM}"                                      1>&2
fi

if [[ -z "${TARGET_LANGUAGES}" ]]; then
	echo "No user-specified languages supplied, will iterate through all available languages: ${AVAILABLE_LANGUAGES}" 1>&2
else 
	echo "User-specified languages to iterate through: ${TARGET_LANGUAGES}"                                                       1>&2
fi
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

TARGET_PLATFORM=${TARGET_PLATFORM:-${DETECTED_PLATFORM}}
TARGET_LANGUAGES=${TARGET_LANGUAGES:-${AVAILABLE_LANGUAGES}}

SCRIPT_CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

passedTests=()
failedTests=()
actualResult=""

runTests() {
	mkdir -p "${SCRIPT_CURRENT_DIR}/logs"

	for TARGET_LANGUAGE in ${TARGET_LANGUAGES}; do
		echo "" 1>&2
		echo "Generating and testing the runner package for the '${TARGET_LANGUAGE}' language running on '${TARGET_PLATFORM}'" 1>&2

		runGenerateBundle
        runTestOnBundle

		outcome=Passed

		if [[ "${actualResult}" = "" ]]; then
		   echo "Test failed due to result mismatch"      1>&2
		   echo "   Actual result: '${actualResult}'"     1>&2
		   echo "   Expected result (should have contained these two lines at the bottom):" 1>&2
		   echo "INFO  [main]       - Starting recording app."                              1>&2
		   echo "INFO  [main]       - ~~~~~~ Self test completed successfully ~~~~~~."      1>&2
		   outcome=Failed
		fi

		recordTestOutcome ${outcome}
		echo "Please check ${GENERATE_LOGS} and ${TEST_RUN_LOGS}, it contains both info (and error) logs for the generate and test run steps respectively" 1>&2
		cleanup
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" 1>&2
	done
}

recordTestOutcome() {
	outcome=$1
	ENTRY="platform=${TARGET_PLATFORM}|language=${TARGET_LANGUAGE}"
	if [[ "${outcome}" = "Passed" ]]; then
		passedTests+=("${ENTRY}")
	elif [[ "${outcome}" = "Failed" ]]; then
		failedTests+=("${ENTRY}")
	fi

	echo "~~~~ Test ${outcome} ~~~~" 1>&2
}

displayPassFailSummary(){
    echo ""                                    1>&2
    echo "~~~ Summary of test executions ~~~"  1>&2
    echo "  ~~~ Passed Tests ~~~"              1>&2
    for passedTest in ${passedTests[@]}
    do
        echo "  ${passedTest}"                 1>&2
    done
    echo "  ${#passedTests[@]} test(s) passed" 1>&2

    echo ""                                    1>&2
    echo "  ~~~ Failed Tests ~~~"              1>&2
    for failedTest in ${failedTests[@]}
    do
        echo "  ${failedTest}"                 1>&2
    done
    echo "  ${#failedTests[@]} test(s) failed" 1>&2
}

cleanup() {
  echo "Cleaning up run_tmp and work folders" 1>&2	
  rm -fr ${SCRIPT_CURRENT_DIR}/run_tmp || true
  rm -fr ${SCRIPT_CURRENT_DIR}/work || true
}

runGenerateBundle() {
    echo " ~~~ Generating the runner package ~~~" 1>&2
    GENERATE_LOGS="${SCRIPT_CURRENT_DIR}/logs/tdl-runner-${TARGET_PLATFORM}-${TARGET_LANGUAGE}-generate.logs"
    rm "${GENERATE_LOGS}" &>/dev/null || true
    (cd ${SCRIPT_CURRENT_DIR} && time ./generate_language_platform_bundle.sh "${TARGET_LANGUAGE}" "${TARGET_PLATFORM}" &> "${GENERATE_LOGS}" || true)
}

checkForCredentialsFile() {
    echo "CREDENTIALS_CONFIG_FILE=${CREDENTIALS_CONFIG_FILE:-}"
    if [[ -z "${CREDENTIALS_CONFIG_FILE:-}" ]]; then
       echo "Credentials config is not defined in CREDENTIALS_CONFIG_FILE, please set it to a valid file."
       exit -1
    fi

    echo "Copying ${CREDENTIALS_CONFIG_FILE:-} to ${SCRIPT_CURRENT_DIR}/run_tmp/accelerate_runner/config/credentials.config"
    cp ${CREDENTIALS_CONFIG_FILE} ${SCRIPT_CURRENT_DIR}/run_tmp/accelerate_runner/config/credentials.config
}

runTestOnBundle() {
    echo "" 1>&2
    echo " ~~~ Now testing the generated runner package: --run-self-test enabled ~~~" 1>&2
    TEST_RUN_LOGS="${SCRIPT_CURRENT_DIR}/logs/tdl-runner-${TARGET_PLATFORM}-${TARGET_LANGUAGE}-self-test.logs"
    rm "${TEST_RUN_LOGS}" &>/dev/null || true
    ( cd ${SCRIPT_CURRENT_DIR} && time ./test_run.sh "${TARGET_LANGUAGE}" "${TARGET_PLATFORM}" &> "${TEST_RUN_LOGS}" || true)
    actualResult=$(grep "Self test completed successfully" "${TEST_RUN_LOGS}" || true)

    checkForCredentialsFile

    echo "" 1>&2
    echo " ~~~ Now testing the generated runner package: video capturing enabled ~~~" 1>&2
    echo " ~~~ [Run the script to write to some source file in the package bundle] ~~~" 1>&2
    echo " ~~~ [Press ctrl-break or ctrl-c to break execution] ~~~" 1>&2
    cd ${SCRIPT_CURRENT_DIR} && time testRun || true
    echo " ~~~ [Check if the video and source code files have been correctly created] ~~~" 1>&2
    read -t 10 -p "Hit ENTER or wait ten seconds"

    echo "" 1>&2
    echo " ~~~ Now testing the generated runner package: --no-video enabled ~~~" 1>&2
    echo " ~~~ [Run the script to write to some source file in the package bundle] ~~~" 1>&2
    echo " ~~~ [Press ctrl-break or ctrl-c to break execution] ~~~" 1>&2
    cd ${SCRIPT_CURRENT_DIR} && time testRun --no-video || true
    echo " ~~~ [Check if the source code files have been correctly created] ~~~" 1>&2
    read -t 10 -p "Hit ENTER or wait ten seconds"
}

testRun() {
    FLAGS=$@

    RUN_TEMP_DIR="${SCRIPT_CURRENT_DIR}/run_tmp"
    "${RUN_TEMP_DIR}/accelerate_runner/record_screen_and_upload.sh" ${FLAGS}

    echo " ~~~~~~ Copying video and source artifacts to test-results folder ~~~~~~"
    TARGET_TEST_RESULTS_FOLDER=${SCRIPT_CURRENT_DIR}/test-results/${TARGET_PLATFORM}/${TARGET_LANGUAGE}
    mkdir -p ${TARGET_TEST_RESULTS_FOLDER}

    cp ${RUN_TEMP_DIR}/accelerate_runner/record/localstore/*.* ${TARGET_TEST_RESULTS_FOLDER}
    ls -lash ${TARGET_TEST_RESULTS_FOLDER}
}

time runTests
displayPassFailSummary
