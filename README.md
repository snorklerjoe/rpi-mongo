# Unofficial MongoDB Docker Builds

ARM64 architectures less than arm64v8.2 are unsupported in official builds. The solution?

I made some scripts to **build MongoDB from the source**, and package it into a docker image that's **drop-in compatible with the official image**!


# :warning: Under Development! :warning:
It doesn't really work yet, but it probably will eventually.

**I don't have time to finish this right now. Current development is happening in a different branch.**

If you want to fork this, look at that other branch. This is something that there seems to be some amount of demand for on the internet.

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
