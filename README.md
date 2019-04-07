[![Build Status](https://travis-ci.com/cjolowicz/docker-buildbot.svg?branch=master)](https://travis-ci.com/cjolowicz/docker-buildbot)
[![Docker Hub](https://img.shields.io/docker/cloud/build/cjolowicz/buildbot.svg)](https://hub.docker.com/r/cjolowicz/buildbot)
[![Buildbot](https://img.shields.io/badge/buildbot-2.1.0-brightgreen.svg)](https://buildbot.net/)

# docker-buildbot

This repository contains a [Docker image](buildbot/Dockerfile) for
[buildbot](https://buildbot.net/), the Continuous Integration
Framework. The image runs the buildbot master with a sample
configuration.

This project has a [changelog](CHANGELOG.md).

## How to use this image

### Getting started

To get started quickly, clone the Git repository and run
`docker-compose up` from inside it. This will start a buildbot master
container with sensible defaults.

When the container has started up, point your browser to
http://localhost:8010 to access the web interface. Navigate to
_Builds_ > _Builders_ > _hello-world_, and click the _trigger_ button.

To stop the container, press `CTRL+C` in the terminal where
`docker-compose` was invoked.

### Starting the container

```sh
$ docker run --init -d cjolowicz/buildbot
```

You should always pass the `--init` option to ensure zombie processes
created by builds are reaped during the lifetime of each container.

If your version of Docker does not support the `--init` option, you
can use the following simple `Dockerfile` to generate an image with
[tini](https://github.com/krallin/tini) installed:

```Dockerfile
FROM cjolowicz/buildbot
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "docker-entrypoint.sh"]
```

Then build the image with `docker build -t custom-buildbot .` and run
it as follows:

```sh
$ docker run -d custom-buildbot
```

### Exposing the web port

```sh
$ docker run --init -p 8010:8010 -d cjolowicz/buildbot
```

When the container has started up, point your browser to
http://localhost:8010 to access the web interface. This is not
required if you provide access to the web interface by other means,
such as an `nginx` container running on the same Docker network.

### Configuring the buildbot URL

```sh
$ docker run --init -e BUILDBOT_URL=http://some-buildbot-host/ -d cjolowicz/buildbot
```

Use the `BUILDBOT_URL` environment variable to configure the external
URL at which the web interface is accessed. This corresponds to the
`buildbotURL` entry in `BuildmasterConfig`. If `BUILDBOT_URL` is unset
or empty, `buildbotURL` defaults to `http://localhost:8010`.

An incorrect buildbot URL results in errors in the web interface,
because requests to the API violate the _Same Origin Policy_. An
example would be the following message when triggering a build:

    "invalid origin"

### Exposing the buildbot port

```sh
$ docker run --init -p 9989:9989 -d cjolowicz/buildbot
```

Expose port 9989 to allow buildbot workers to access the master at
this port on the Docker host. This is not required if workers are run
as containers on the same Docker network.

### Providing a volume for program data

```sh
$ docker run --init -v buildbot-volume:/var/lib/buildbot -d cjolowicz/buildbot
```

Program data such as the buildbot database is stored in a volume
mounted at `/var/lib/buildbot` in the container. It is recommended to
provide a named volume to persist this data between containers.

### Dropping privileges

The Docker container drops privileges on startup using
[su-exec](https://github.com/ncopa/su-exec). See the provided
[entrypoint script](buildbot/docker-entrypoint.sh) for the
detailed startup sequence.

### Configuring buildbot

Buildbot is configured using the file
[`/etc/buildbot/master.cfg`](buildbot/master.cfg) in the container.

#### Using the sample configuration

The sample configuration provided with this image demonstrates the use
of different types of workers. The behaviour depends on whether the
Docker daemon is accessible from the container.

If the Docker daemon is not accessible from the container:

- If `WORKERNAME` and `WORKERPASS` are provided, `worker.Worker` is
  used. This allows a worker to connect to the master at port 9989
  using the given credentials.
- Otherwise, `worker.LocalWorker` is used. This will run a worker on
  the same host and in the same process as the buildbot master.

If the Docker daemon is accessible from the container:

- If the daemon is configured as a manager node on a Docker Swarm,
  `DockerSwarmLatentWorker` from the
  [buildbot-docker-swarm-worker](https://pypi.org/project/buildbot-docker-swarm-worker/)
  plugin is used. This allows the master to spawn workers as swarm
  services on demand.
- Otherwise, `worker.DockerLatentWorker` is used. This allows the
  master to spawn workers as sibling containers on demand.

The sample build will download the source tarball from buildbot's
[hello-world](https://github.com/buildbot/hello-world) repository and
run its test suite. The build must be triggered explicitly using the
_trigger_ button on the builder page.

#### Providing your own configuration

You can provide your own configuration by bind-mounting it onto
`/etc/buildbot/master.cfg`:

```sh
$ docker run --init -v /host/path/master.cfg:/etc/buildbot/master.cfg:ro -d cjolowicz/buildbot
```

This can also be accomplished more cleanly using a simple `Dockerfile`
(in `/host/path/`):

```Dockerfile
FROM cjolowicz/buildbot
COPY master.cfg /etc/buildbot/master.cfg
```

Then build the image with `docker build -t custom-buildbot .` and run
it as follows:

```sh
$ docker run -d custom-buildbot
```

### Running builds in the master container

This can be achieved by using `worker.LocalWorker` in the buildbot
configuration, as demonstrated by the sample
[master.cfg](buildbot/master.cfg).

You need to ensure that the image has the required build toolchain
installed. By default, the master image only provides the following
Alpine packages:

- [build-base](https://pkgs.alpinelinux.org/package/v3.9/main/x86_64/build-base)
- [python3-dev](https://pkgs.alpinelinux.org/package/v3.9/main/x86_64/python3-dev)
- [openssl-dev](https://pkgs.alpinelinux.org/package/v3.9/main/x86_64/openssl-dev)

Additional tools will need to be installed using the `apk` package
manager in your own `Dockerfile`. Also note that Alpine uses
[musl](https://www.musl-libc.org/) instead of
[glibc](https://www.gnu.org/software/libc/).

### Running builds in worker containers

See
[cjolowicz/buildbot-worker](https://hub.docker.com/r/cjolowicz/buildbot-worker)
for a collection of buildbot worker images for various
platforms. Worker containers can be long-running or spawned on
demand. See the next section for the latter option.

Use `worker.Worker` in the master configuration, and supply the master
hostname, worker name, and worker password to the worker container via
environment variables:

```sh
$ export BUILDMASTER=buildbot
$ export WORKERNAME=worker
$ docker network create buildbot-net
$ docker run --init --network buildbot-net --name $BUILDMASTER \
    -p 8010:8010 -d cjolowicz/buildbot
$ docker run --init --network buildbot-net --name $WORKERNAME \
    -e BUILDMASTER -e WORKERNAME -e WORKERPASS=secret \
    -d cjolowicz/buildbot-worker
```

### Bind-mounting the Docker daemon socket

The master container can spawn buildbot workers as sibling containers
on demand using `worker.DockerLatentWorker`. The containers are
stopped and removed when the build is finished.

Unlike long-running worker containers, on-demand workers are provided
automatically with an environment that allows them to connect back to
the master.

This requires that the Docker daemon socket is bind-mounted into the
master container:

```sh
$ docker run --init -v /var/run/docker.sock:/var/run/docker.sock -d cjolowicz/buildbot
```

Note that this has important
[security implications](https://docs.docker.com/engine/security/security/). Essentially,
access to the Docker daemon socket implies root privileges on the
Docker host.

### Spawning workers on a Docker Swarm cluster

When run on a Docker Swarm cluster, the master container can spawn
buildbot workers as swarm services on demand using
`worker.DockerSwarmLatentWorker` from the
[buildbot-docker-swarm-worker](https://pypi.org/project/buildbot-docker-swarm-worker/)
plugin.

This requires that the buildbot master is started as a Docker service
on the manager node of the Docker Swarm, and that the Docker daemon
socket is bind-mounted into the master container.

Consider using the provided [buildbot.yml](buildbot.yml) to deploy a
Docker stack with sensible defaults. See below for details.

### Use with Docker Compose

Use the supplied [docker-compose.yml](docker-compose.yml) file to
start the master container with sensible defaults:

```shell
$ docker-compose up -d
```

### Use with Docker Swarm

Use the supplied [buildbot.yml](buildbot.yml) file to start the master
container as a service on Docker Swarm:

```shell
$ eval $(./buildbot-env.sh)
$ docker stack deploy -c buildbot.yml buildbot
```

The script [buildbot-env.sh](buildbot-env.sh) prints shell commands to
set up environment variables for buildbot deployment. The output of
this script should be evaluated by the calling shell, as shown
above. This is required after every change to `master.cfg`, for the
new configuration to get deployed to the stack.

If `BUILDBOT_URL` is unset but `DOCKER_HOST` is set, its value is used
to provide a default for `BUILDBOT_URL`.

## Building the Docker image

Building the Docker image requires
[GNU make](https://www.gnu.org/software/make/).

Here is a list of available targets:

| Target | Description |
| --- | --- |
| `make build` | Build the image. |
| `make push` | Upload the image to Docker Hub. |
| `make pull` | Download the image from Docker Hub. |
| `make login` | Log into Docker Hub. |

Pass `NAMESPACE` to prefix the image with a Docker Hub namespace. The
default is `DOCKER_USERNAME`.

The `login` target is provided for non-interactive use and looks
for `DOCKER_USERNAME` and `DOCKER_PASSWORD`.

## Related projects

- https://github.com/cjolowicz/buildbot-docker-swarm-worker
- https://github.com/cjolowicz/docker-buildbot-worker
