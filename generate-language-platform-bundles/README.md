# Generate language + platform bundles

### Create bundle
(note: the below command can be run in a Linux/MacOS environment)
```
./generate_language_platform_bundle.sh csharp macos
./generate_language_platform_bundle.sh csharp linux
./generate_language_platform_bundle.sh csharp windows
./generate_language_platform_bundle.sh fsharp macos
./generate_language_platform_bundle.sh fsharp linux
./generate_language_platform_bundle.sh fsharp windows
./generate_language_platform_bundle.sh vbnet macos
./generate_language_platform_bundle.sh vbnet linux
./generate_language_platform_bundle.sh vbnet windows
```

To generate all bundles run
```
./generate_all_bundles.sh
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
