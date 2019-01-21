@if "%DEBUG%" == "" @echo off

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set SCRIPT_CURRENT_DIR=%DIRNAME%

set JAVA_BIN="%SCRIPT_CURRENT_DIR%/jre/bin/java.exe"
set JAR_FILE="%SCRIPT_CURRENT_DIR%/record/bin/record-and-upload.jar"
set PARAM_CONFIG_FILE=%SCRIPT_CURRENT_DIR%/config/credentials.config
set PARAM_STORE_DIR=%SCRIPT_CURRENT_DIR%/record/localstore
set PARAM_SOURCECODE_DIR=%SCRIPT_CURRENT_DIR%
set CMD_LINE_ARGS=%*

echo "Running using packaged JRE:"

echo "Checking if Windows 10 or higher version is running"
@rem 
@rem This regex in findstr will check for a version number of the 
@rem format 99.9 or 99.99 and will flag them as Windows 10 or higher
@rem * means zero or more, see https://ss64.com/nt/findstr.html
@rem unfortunately, findstr regex does NOT support the + notation (for atleast one or more)
@rem 
ver | findstr /i "[1-9][0-9]\.[0-9]*\." > nul
if %ERRORLEVEL% == 0 goto windows10

@echo on
@rem Execute Record

:PreWindows10
echo "Pre-Windows 10 version detected"
ver
%JAVA_BIN%                               ^
     -jar %JAR_FILE%                     ^
     --config %PARAM_CONFIG_FILE%        ^
     --store %PARAM_STORE_DIR%           ^
     --sourcecode %PARAM_SOURCECODE_DIR% ^
     %CMD_LINE_ARGS%

goto finish

:windows10
echo "Windows 10 or higher version detected"
ver

@rem
@rem Can also be resolved by using -Dlogback.configurationFile=".\record\bin\logback.xml"
@rem instead of the below          -Dlogback.enableJansi="false"
@rem to make logback use a different config xml file containing the new setting to switch off Jansi
@rem

%JAVA_BIN%                               ^
     -Dlogback.enableJansi="false"       ^
     -jar %JAR_FILE%                     ^
     --config %PARAM_CONFIG_FILE%        ^
     --store %PARAM_STORE_DIR%           ^
     --sourcecode %PARAM_SOURCECODE_DIR% ^
     %CMD_LINE_ARGS%

:finish
@echo off