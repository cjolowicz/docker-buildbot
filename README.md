[![Build Status](https://travis-ci.com/cjolowicz/docker-buildbot-master.svg?branch=master)](https://travis-ci.com/cjolowicz/docker-buildbot-master)
[![Docker Hub](https://img.shields.io/docker/cloud/build/cjolowicz/buildbot-master.svg)](https://hub.docker.com/r/cjolowicz/buildbot-master)
[![Buildbot](https://img.shields.io/badge/buildbot-1.8.0-brightgreen.svg)](https://buildbot.net/)

# docker-buildbot-master

This repository contains a Docker image for
[buildbot master](https://buildbot.net/). The Docker image is loosely
based on the
[official image](https://github.com/buildbot/buildbot/tree/master/master/Dockerfile).

This project has a [changelog](CHANGELOG.md).

## Usage

Use the provided [docker-compose.yml](docker-compose.yml) file to start the
container. This will mount a volume onto `/var/lib/buildbot`,
containing a sample `master.cfg` file.

## Building

Building the Docker image requires
[GNU make](https://www.gnu.org/software/make/).

Here is a list of available targets:

| Target | Description |
| --- | --- |
| `make build` | Build the image. |
| `make push` | Upload the image to Docker Hub. |
| `make login` | Log into Docker Hub. |

Pass `REPO` to prefix the image with a Docker Hub repository name. The
default is `DOCKER_USERNAME`.

The `login` target is provided for non-interactive use and looks
for `DOCKER_USERNAME` and `DOCKER_PASSWORD`.
