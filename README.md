[![Build Status](https://travis-ci.com/cjolowicz/docker-buildbot.svg?branch=master)](https://travis-ci.com/cjolowicz/docker-buildbot)
[![Docker Hub](https://img.shields.io/docker/cloud/build/cjolowicz/buildbot.svg)](https://hub.docker.com/r/cjolowicz/buildbot)
[![Buildbot](https://img.shields.io/badge/buildbot-1.8.0-brightgreen.svg)](https://buildbot.net/)

# docker-buildbot

This repository contains a [Docker image](buildbot/Dockerfile) for
[buildbot](https://buildbot.net/), the Continuous Integration
Framework. The container runs an instance of the buildbot master.
Buildbot workers are spawned as sibling containers, on demand.

This project has a [changelog](CHANGELOG.md).

## Usage

Use the supplied [docker-compose.yml](docker-compose.yml) file to
start the master container. Here is a one-liner to get you started:

```shell
curl -L https://raw.githubusercontent.com/cjolowicz/docker-buildbot/master/docker-compose.yml | \
    docker-compose -f- up
```

Then point your browser to http://localhost:8010 to access the web
interface.

Navigate to _Builds_ > _Builders_ > _hello-world_, and click the
_trigger_ button.

## Configuration

Docker Compose creates a volume for `/var/lib/buildbot`, and
pre-populates it with a sample [master.cfg](buildbot/master.cfg)
file. To supply your own buildbot configuration, either install it to
the volume, or derive your own image.

Expose port 9989 on the host if you need to run workers outside of
Docker. This is done by adding the following line to the `ports`
section of `docker-compose.yml`:

```yaml
      - "9989:9989"
```

## Differences from upstream

This Docker image is loosely based on the buildbot
[official image](https://github.com/buildbot/buildbot/tree/master/master/Dockerfile),
but there are some important differences.

This Docker image is designed to spawn buildbot workers as sibling
containers, on demand. To this purpose, the Docker daemon socket is
bind-mounted into the container. The Docker daemon socket is expected
to be located at `/var/run/docker.sock`, and it must be
group-writable.

The Docker container drops privileges on startup using
[su-exec](https://github.com/ncopa/su-exec). See the provided
[entrypoint script](buildbot/docker-entrypoint.sh) for the
detailed startup sequence.

This Docker image does not have
[dumb-init](https://github.com/Yelp/dumb-init) installed. Modern
versions of Docker ship with [tini](https://github.com/krallin/tini),
which provides the same functionality. If you are running an older
version of Docker, you will need to install `tini` in your master and
worker images, to ensure zombie processes created by builds are reaped
during the lifetime of each container.

## Building the Docker images

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
