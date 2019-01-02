# Generate language + platform bundles

Create bundle
```
./generate_language_platform_bundle.sh java macos
```

Test bundle
```
./test_run.sh java macos
```

Sync to S3 bucket
```
(cd ./build && aws s3 sync . s3://get.accelerate.io/)
```