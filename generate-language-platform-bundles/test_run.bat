@if "%DEBUG%" == "" @echo off

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set SCRIPT_CURRENT_DIR=%DIRNAME%

set RUN_TEMP_DIR=%SCRIPT_CURRENT_DIR%\run_tmp
rm -Rf "%RUN_TEMP_DIR%"
mkdir "%RUN_TEMP_DIR%"

@rem  Read input
@rem if [ $# -ne 3 ]; then
@rem  echo "Syntax is: $0 language platform architecture"
@rem  exit 1
@rem fi

set TARGET_LANGUAGE=%1
set TARGET_PLATFORM=%2
set TARGET_ARCH=%3

@rem Read input
if not defined TARGET_LANGUAGE goto fail
if not defined TARGET_PLATFORM goto fail

@rem Extract
set BUNDLE_ZIP=%SCRIPT_CURRENT_DIR%\build\runner-for-%TARGET_LANGUAGE%-%TARGET_PLATFORM%-%TARGET_ARCH%.zip

unzip "%BUNDLE_ZIP%" -d "%RUN_TEMP_DIR%"

@rem Invoke JRE
%RUN_TEMP_DIR%\accelerate_runner\track_code_and_upload.bat --help

:fail
echo "Syntax is: $0 language platform architecture"
exit 1

:finish