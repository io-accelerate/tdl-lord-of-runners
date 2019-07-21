# Generate language + platform bundles

### Create bundle
(note: the below command can be run in a Linux/MacOS environment, or in a Windows environment via Cygwin)
```
./generate_language_platform_bundle.sh java macos
./generate_language_platform_bundle.sh java linux
./generate_language_platform_bundle.sh java windows
```

### Test bundle Linux/MacOS environment
```
./test_run.sh java macos
./test_run.sh java linux
```

### Test bundle Windows environment
```
test_run.bat java windows
```

### Sync to S3 bucket
(note: permissions needed to push to this s3 bucket)

```
(cd ./build && aws s3 sync . s3://get.accelerate.io/)
```

### Manually testing

Individual bundles that are generated using the `generate_language_platform_bundle.sh` can be tested using the above steps.

To bulk smoke test one or more bundles across multiple platforms that have been already created and uploaded to the http://get.accelerate.io/ can be done using a bunch of scripts:

- `test_run.bat` - will run test on a language bundle for Windows
- `test_run.sh` - will run test on a language bundle for Linux or MacOS
