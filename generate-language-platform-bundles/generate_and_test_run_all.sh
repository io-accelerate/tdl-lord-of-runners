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

runTests() {
	mkdir -p "${SCRIPT_CURRENT_DIR}/logs"

	for TARGET_LANGUAGE in ${TARGET_LANGUAGES}; do
		echo "" 1>&2
		echo "Generating and testing the runner package for the '${TARGET_LANGUAGE}' language running on '${TARGET_PLATFORM}'" 1>&2

		echo " ~~~ Generating the runner package ~~~" 1>&2
		GENERATE_LOGS="${SCRIPT_CURRENT_DIR}/logs/tdl-runner-${TARGET_PLATFORM}-${TARGET_LANGUAGE}-generate.logs"
		rm "${GENERATE_LOGS}" &>/dev/null || true
		(time ./generate_language_platform_bundle.sh "${TARGET_LANGUAGE}" "${TARGET_PLATFORM}" &> "${GENERATE_LOGS}" || true)

		echo "" 1>&2
		echo " ~~~ Now testing the generated runner package ~~~" 1>&2
		TEST_RUN_LOGS="${SCRIPT_CURRENT_DIR}/logs/tdl-runner-${TARGET_PLATFORM}-${TARGET_LANGUAGE}-test-run.logs"
		rm "${TEST_RUN_LOGS}" &>/dev/null || true
		(time ./test_run.sh "${TARGET_LANGUAGE}" "${TARGET_PLATFORM}" &> "${TEST_RUN_LOGS}" || true)
		actualResult=$(grep "Self test completed successfully" "${TEST_RUN_LOGS}" || true)

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
  rm -fr run_tmp || true
  rm -fr work || true
}

time runTests
displayPassFailSummary
cleanup