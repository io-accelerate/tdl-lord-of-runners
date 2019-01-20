# Generate language + platform bundles

### Create bundle
(note: the below command can be run in a Linux/MacOS environment, or in a Windows environment via Cygwin)
```
./generate_language_platform_bundle.sh java macos
./generate_language_platform_bundle.sh java linux
./generate_language_platform_bundle.sh java windows
```

### Test bundle
```
./test_run.sh java macos                         <== can be run in a Linux/MacOS environment
./test_run.sh java linux                         <== can be run in a Linux/MacOS environment

test_run.bat java windows                        <== can be run in a Windows only environment
```

### Sync to S3 bucket
(note: permissions needed to push to this s3 bucket)

```
(cd ./build && aws s3 sync . s3://get.accelerate.io/)
```

### Manually testing

Individual bundles that are generated using the `generate_language_platform_bundle.sh` can be tested using the above steps.

To bulk smoke test one or more bundles across multiple platforms that have been already created and uploaded to the http://get.accelerate.io/ can be done using a bunch of scripts:

- `testing/download_bundles_and_test_run_all.sh` - will detect the platform it is running on i.e. `linux`, `macos` or `windows` and download the respective language bundles for the respective platform and run various tests on them
- `test_run.bat` - will run test on a language bundle for Windows
- `test_run.sh` - will run test on a language bundle for Linux or MacOS

And supported by scripts like:

- `runDockerContainer.sh` - run a docker instance and mount the current folder into it, to allow running the recorder and the challenges in an isolated environment
- `testing/sendCtrlCToRecorder.sh` - sends a Ctrl-C signal to the running JAR process on Linux/MacOS and a Ctrl-C to the batch on Windows

Steps to follow (all platforms):

- Go to the http://intro.befaster.io... provided by the administrator to download the credentials config file
- set the environment variable `CREDENTIALS_CONFIG_FILE` to point to this config file with the command `export CREDENTIALS_CONFIG_FILE="/path/to/the/downloaded/credentials.config"`
- run `testing/download_bundles_and_test_run_all.sh` in one terminal 
- wait for the run-self-test of a language to be performed or the message "run-self-test has already been performed, moving further..."
- this moves to the second test "video-capturing-enabled-test"
- open a second terminal and go to the `tdl-lord-of-runners/generate-language-platform-bundles` folder
- in the second terminal, go to the `run_tmp/accelerate_runner` folder 
- in the second terminal, depending on the language, run the build system for it i.e. `./gradlew run` for `java`, etc...
- in the second terminal, follow the instructions on the screen to complete the respective round
- either complete the whole challenge or after the current round, run the `tdl-lord-of-runners/generate-language-platform-bundles/testing/sendCtrlCToRecorder.sh` in a separate terminal
- or switch to the first terminal and press `Ctrl-C`
- in the first terminal, then please a key or wait for 10 seconds for the next recorder test to start
- this moves to the third test "video-capturing-disabled-test"
- switch to the second terminal and follow the same process as above for this recorder test
- in the second terminal, ar the end of the third test, come out of the `run_tmp/accelerate_runner` with a `cd ../..` command
- in the first terminal, wait for the next language test to start (wait for the "video-capturing-enabled-test" test)
- continue with the above cycle from the beginning

Other usages of the above scripts:

- `TARGET_LANGUAGES="java" ./testing/download_bundles_and_test_run_all.sh`
- `TARGET_LANGUAGES="java scala" ./testing/download_bundles_and_test_run_all.sh`

For Windows the below conventions will need to be followed:

- Run a VM with Windows 10 and tools like git-bash, and all the necessary dependencies in order for the respective runner bundles to run, required dependencies are listed in the README of each language bundle
- use one of the below commands to set the environment variable `CREDENTIALS_CONFIG_FILE`:

	```
	export CREDENTIALS_CONFIG_FILE="/f/tdl-runner-java/config/credentials.config"
	set CREDENTIAL_CONFIG_FILE=f:\tdl-runner-java\config\credentials.config
	```
- for example, for Csharp, Fsharp, VBNet, we need `nuget.exe` and `msbuild` which can be downloaded from Microsoft's website, on the local machine `msbuild` is usually located at `/c/Program Files (x86)/MSBuild/14.0/Bin/MsBuild.exe` or `/c/Program Files/MSBuild/14.0/Bin/MsBuild.exe`

Things to know about the manual tests:
- the logs folder records the output of the run-self-test (first recorder test) 
- output of each test step for the respective platform and language is recorded in the `test-results` folder
- outputs created are .log files, .mp4 video files and .srcs source archive files
- each test step is remembered by the script via an empty file stored in the `test-results/[PLATFORM]/[LANGUAGE]` folder, known markers:  run-self-test, video-capturing-enabled-test, video-capturing-disabled-test
- once a test is successfully completed it won't repeat it, but will be skipped for the next one and so forth, in order to repeat a test, delete the marker file in the `test-results/[platform]/[language]` folder
- in Windows, the Ctrl-C action or the `testing/sendCtrlCToRecorder.sh` behaves differently, the pause between tests does not happen it moves to the next test immediately