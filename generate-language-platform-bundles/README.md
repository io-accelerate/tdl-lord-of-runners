# Generate language + platform bundles

### Create bundle
(note: the below command can be run in a Linux/MacOS environment)
```
./generate_language_platform_bundle.sh nodejs macos x64
./generate_language_platform_bundle.sh nodejs macos aarch64
./generate_language_platform_bundle.sh nodejs linux x64
./generate_language_platform_bundle.sh nodejs linux aarch64
./generate_language_platform_bundle.sh nodejs windows x64
./generate_language_platform_bundle.sh nodejs windows aarch64
```

To generate all bundles run
```
./generate_all_bundles.sh
```

### Test bundle Linux/MacOS environment
```
./test_run.sh java macos x64
./test_run.sh java macos aarch64
./test_run.sh java linux x64
./test_run.sh java linux aarch64
```

### Test bundle Windows environment
```
test_run.bat java windows x64
```

### Sync to S3 bucket
(note: permissions needed to push to this s3 bucket)

```
(cd ./build && aws s3 sync . s3://get.accelerate.io/)
```

### Invalidate CloudFront cache

Login to AWS and run create an invalidation for the "get.accelerate.io" CloudFront distribution.

### Manually testing

Individual bundles that are generated using the `generate_language_platform_bundle.sh` can be tested using the above steps.

To bulk smoke test one or more bundles across multiple platforms that have been already created and uploaded to the http://get.accelerate.io/ can be done using a bunch of scripts:

- `test_run.bat` - will run test on a language bundle for Windows
- `test_run.sh` - will run test on a language bundle for Linux or MacOS
