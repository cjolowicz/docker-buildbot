[![Build Status](https://travis-ci.com/cjolowicz/docker-buildbot-master.svg?branch=master)](https://travis-ci.com/cjolowicz/docker-buildbot-master)
[![Docker Hub](https://img.shields.io/docker/cloud/build/cjolowicz/buildbot-master.svg)](https://hub.docker.com/r/cjolowicz/buildbot-master)
[![Buildbot](https://img.shields.io/badge/buildbot-1.8.0-brightgreen.svg)](https://buildbot.net/)

# docker-buildbot-master

This repository contains a [Docker image](buildbot-master/Dockerfile)
for [buildbot](https://buildbot.net/).

This project has a [changelog](CHANGELOG.md).

## Usage

Use `docker-compose up` with the supplied
[docker-compose.yml](docker-compose.yml) file to start the master
container. Then point your browser to http://localhost:8010.

```shell
curl -L https://github.com/cjolowicz/docker-buildbot-master/blob/master/docker-compose.yml | docker-compose -f- up
```

This creates a volume for `/var/lib/buildbot`, and pre-populates it
with a sample [master.cfg](buildbot-master/master.cfg) file. To supply
your own buildbot configuration, either install it to the volume, or
derive your own image.

## Differences from upstream

This Docker image is loosely based on the buildbot
[official image](https://github.com/buildbot/buildbot/tree/master/master/Dockerfile),
but there are some important differences.

This Docker image is designed to spawn buildbot workers on demand, as
sibling containers. To this purpose, the Docker daemon socket is
bind-mounted into the container. The Docker daemon socket is expected
to be located at `/var/run/docker.sock`, and it must be group-writable.

The Docker container drops privileges on startup using
[su-exec](https://github.com/ncopa/su-exec). See the provided
[entrypoint script](buildbot-master/docker-entrypoint.sh) for the
detailed startup sequence.

This Docker image does not have
[dumb-init](https://github.com/Yelp/dumb-init) installed. Modern
versions of Docker ship with [tini](https://github.com/krallin/tini),
which provides the same functionality. If you are running an older
version of Docker, you will need to install `tini` in your master and
worker images, to ensure zombie processes created by builds are reaped
during the lifetime of each container.

## Building

The supplied [Makefile](Makefile) will build the master image as well
as an example worker image used by the sample configuration. Building
the Docker images requires
[GNU make](https://www.gnu.org/software/make/).

Here is a list of available targets:

| Target | Description |
| --- | --- |
| `make build` | Build the images. |
| `make push` | Upload the images to Docker Hub. |
| `make login` | Log into Docker Hub. |

Pass `NAMESPACE` to prefix the images with a Docker Hub namespace. The
default is `DOCKER_USERNAME`.

The `login` target is provided for non-interactive use and looks
for `DOCKER_USERNAME` and `DOCKER_PASSWORD`.
