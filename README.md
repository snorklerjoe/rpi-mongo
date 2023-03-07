# Unofficial MongoDB Docker Builds

ARM64 architectures less than arm64v8.2 are unsupported in official builds. The solution?

I made some scripts to **build MongoDB from the source**, and package it into a docker image that's **drop-in compatible with the official image**!


# :warning: Under Development! :warning:
It doesn't really work yet, but it probably will in the next day or so.


## The Goal
- Maintained images
- Supporting several raspi architectures
- Multiple versions of MongoDB

Sounds too good to be true? It probably is.

Keep in mind I'm literally just a high-school student putting this together on the last day of February break.

## Images
Find [these images](https://hub.docker.com/r/snorklerjoe/rpi-mongo) on Docker Hub!

## Current targets:

| Tag       | Mongo Version | Target Platform | Support | Architecture |
| ---       | ------------- | --------------- | ------- | ------------ |
| [raspi4-4.4](https://hub.docker.com/layers/snorklerjoe/rpi-mongo/raspi4-4.4/images/sha256-0650a910d8a9857d3985241a296bd5c5df2f117bd483d4b9b3891b224554f6ec?context=repo)| 4.4           | Raspi 4 model B | In Development | arm64v8|

## Compiling yourself:

1. Install Docker & buildx
2. Install multiarch deps
    ``` bash
    sudo apt install -y qemu-user-static binfmt-support
    ```
3. Use `build.sh`-
    ```
    Usage: ./build.sh [-h/--help] [--reuse-builder] target
    Builds MongoDB from source and creates an unofficial docker image

    target should be the name of a file in the current working directory.
    See the existing target files for examples of how to make your own.

    -h, --help            Show this help message

        --reuse-builder   Reuse the buildx builder instead of pulling a new one

    ```
