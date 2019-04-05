[![Build Status](https://travis-ci.com/cjolowicz/docker-buildbot.svg?branch=master)](https://travis-ci.com/cjolowicz/docker-buildbot)
[![Docker Hub](https://img.shields.io/docker/cloud/build/cjolowicz/buildbot.svg)](https://hub.docker.com/r/cjolowicz/buildbot)
[![Buildbot](https://img.shields.io/badge/buildbot-2.1.0-brightgreen.svg)](https://buildbot.net/)

# docker-buildbot

This repository contains a [Docker image](buildbot/Dockerfile) for
[buildbot](https://buildbot.net/), the Continuous Integration
Framework. The container runs an instance of the buildbot master.
Buildbot workers are spawned as sibling containers, on demand.

This project has a [changelog](CHANGELOG.md).

## Usage

### Docker Compose

Use the supplied [docker-compose.yml](docker-compose.yml) file to
start the master container.

```shell
git clone https://github.com/cjolowicz/docker-buildbot.git
cd docker-buildbot
docker-compose up
```

Then point your browser to http://localhost:8010 to access the web
interface.

Navigate to _Builds_ > _Builders_ > _hello-world_, and click the
_trigger_ button.

Edit [master.cfg](master.cfg) to configure buildbot. This file is
bind-mounted into the container at `/etc/buildbot/master.cfg`.

### Docker Swarm

Use the supplied [buildbot.yml](buildbot.yml) file to deploy the
stack.

```shell
eval $(./buildbot-env.sh)
docker stack deploy --compose-file=buildbot.yml buildbot
```

Buildbot workers are spawned as Docker services, using the
[buildbot-docker-swarm-worker](https://pypi.org/project/buildbot-docker-swarm-worker/)
plugin.

The script [buildbot-env.sh](buildbot-env.sh) prints shell commands to
set up environment variables for buildbot deployment. The output of
this script should be evaluated by the calling shell, as shown
above. This is required after every change to `master.cfg`, for the
new configuration to get deployed to the stack.

## Configuration

### Configuring the buildbot URL

Use the `BUILDBOT_URL` environment variable to configure the external
URL at which the web interface is accessed. This corresponds to the
`buildbotURL` entry in `BuildmasterConfig`.

If `BUILDBOT_URL` is unset but `DOCKER_HOST` is set, its value is used
to provide a default for `BUILDBOT_URL`. Otherwise, `buildbotURL`
defaults to `http://localhost:8010`.

An incorrect buildbot URL results in errors in the web interface,
because requests to the API violate the Same Origin Policy. An example
would be the following message when triggering a build:

    "invalid origin"

### Running workers outside of Docker

Expose port 9989 on the host if you need to run workers outside of
Docker. This is done by adding the following line to the `ports`
section of `docker-compose.yml` or `buildbot.yml`:

```yaml
      - "9989:9989"
```

## Differences from upstream

This Docker image is loosely based on the buildbot
[official image](https://github.com/buildbot/buildbot/tree/master/master/Dockerfile),
but there are some important differences.

### Bind-mounting the Docker daemon socket

This Docker image is designed to spawn buildbot workers as sibling
containers, on demand. To this purpose, the Docker daemon socket is
bind-mounted into the master container. The Docker daemon socket is
expected to be located at `/var/run/docker.sock`, and it must be
group-writable.

Note that this has important
[security implications](https://docs.docker.com/engine/security/security/). Essentially,
access to the Docker daemon socket implies root privileges on the
Docker host.

### Dropping privileges

The Docker container drops privileges on startup using
[su-exec](https://github.com/ncopa/su-exec). See the provided
[entrypoint script](buildbot/docker-entrypoint.sh) for the
detailed startup sequence.

### Reaping zombie processes

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
| `make pull` | Download the images from Docker Hub. |
| `make login` | Log into Docker Hub. |

Pass `NAMESPACE` to prefix the images with a Docker Hub namespace. The
default is `DOCKER_USERNAME`.

The `login` target is provided for non-interactive use and looks
for `DOCKER_USERNAME` and `DOCKER_PASSWORD`.

## Related projects

- https://github.com/cjolowicz/buildbot-docker-swarm-worker
- https://github.com/cjolowicz/docker-buildbot-worker
