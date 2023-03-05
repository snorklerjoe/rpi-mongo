# Unofficial MongoDB Docker Builds
ARM64 architectures less than arm64v8.2 are unsupported in official builds. The solution?

Manual labor.

These build scripts should run okay on Debian... at least once I get this working. I'll also set it up to push to Docker Hub. More info here as I actually get this to work (hopefully in the next several hours or so but we'll see...)

## Current targets:

| Tag       | Mongo Version | Target Platform | Support | Architecture |
| ---       | ------------- | --------------- | ------- | ------------ |
| raspi4-4.4| 4.4           | Raspi 4 model B | In Development | arm64v8|
