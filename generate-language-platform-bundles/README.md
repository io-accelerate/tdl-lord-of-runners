# Generate language + platform bundles

Create bundle
(note: the below command can be run in a Linux/MacOS environment, or in a Windows environment via Cygwin)
```
./generate_language_platform_bundle.sh java macos
./generate_language_platform_bundle.sh java linux
./generate_language_platform_bundle.sh java windows
```

Test bundle
```
./test_run.sh java macos                         <== can be run in a Linux/MacOS environment
./test_run.sh java linux                         <== can be run in a Linux/MacOS environment

test_run.bat java windows                        <== can be run in a Windows only environment
```

Sync to S3 bucket
(note: permissions needed to push to this s3 bucket)

```
(cd ./build && aws s3 sync . s3://get.accelerate.io/)
```
