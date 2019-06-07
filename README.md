[![Build Status](https://travis-ci.com/cjolowicz/docker-buildbot.svg?branch=master)](https://travis-ci.com/cjolowicz/docker-buildbot)
[![Docker Hub](https://img.shields.io/docker/cloud/build/cjolowicz/buildbot.svg)](https://hub.docker.com/r/cjolowicz/buildbot)
[![Buildbot](https://img.shields.io/badge/buildbot-2.1.0-brightgreen.svg)](https://buildbot.net/)

# docker-buildbot

This repository contains a [Docker](https://www.docker.com/) image for
[buildbot](https://buildbot.net/), the Continuous Integration framework. It is
not affiliated with the official buildbot organization.

## Supported tags and respective `Dockerfile` links

- [`2.1.0`, `2.1`, `2`, `latest`](https://github.com/cjolowicz/docker-buildbot/blob/v2.1.0-1/buildbot/Dockerfile)
- [`2.0.1`, `2.0`](https://github.com/cjolowicz/docker-buildbot/blob/v2.0.1-1/buildbot/Dockerfile)
- [`1.8.1`, `1.8`, `1`](https://github.com/cjolowicz/docker-buildbot/blob/v1.8.1-1/buildbot/Dockerfile)
- [`1.8.0`](https://github.com/cjolowicz/docker-buildbot/blob/v1.8.0-1/buildbot/Dockerfile)

## Quick reference

- **Where to file issues**:<br/>
  https://github.com/cjolowicz/docker-buildbot/issues
- **Maintained by**:<br/>
  [Claudio Jolowicz](https://github.com/cjolowicz)
- **Supported Docker versions**:<br/>
  [the latest release](https://github.com/docker/docker-ce/releases/latest)
- **Changelog**:<br/>
  https://github.com/cjolowicz/docker-buildbot/blob/master/CHANGELOG.md

## What is buildbot?

Buildbot is an open-source framework for automating software build, test, and
release processes. Buildbot can automate all aspects of the software development
cycle: Continuous Integration, Continuous Deployment, Release Management, and
any other process you can imagine. Buildbot is a framework in which you
implement a system that matches your workflow and grows with your organization.

[![Buildbot Logo](https://raw.githubusercontent.com/buildbot/buildbot-media/master/images/full_logo.png)](https://buildbot.net/)

## How to use this image

The image runs the buildbot master with a sample configuration.

1. [Getting started](#getting-started)
2. [Modes of operation](#modes-of-operation)
3. [Sample configuration](#sample-configuration)
4. [Important options](#important-options)
5. [Use with Docker Compose](#use-with-docker-compose)
6. [Use with Docker Swarm](#use-with-docker-swarm)

### Getting started

To get started quickly, clone the Git repository and run `docker-compose up`
from inside it. This will start a buildbot master container with sensible
defaults.

When the container has started up, point your browser to http://localhost:8010
to access the web interface. Navigate to _Builds_ > _Builders_ > _hello-world_,
and click the _trigger_ button.

To stop the container, press `CTRL+C` in the terminal where `docker-compose` was
invoked.

### Modes of operation

The [buildbot
architecture](http://docs.buildbot.net/current/manual/introduction.html#system-architecture)
consists of a single build master and one or more workers, connected in a star
topology. This image supports different modes of operation, which may be
combined freely:

- Workers can be run on external hosts.
- Workers can be run inside the master container (_local worker_).
- Workers can be run as sibling containers.
- Workers can be spawned on demand as sibling containers, by the master.

Both master and workers can also be run as services on a [Docker
Swarm](https://docs.docker.com/engine/swarm/) cluster. For example, it is
possible to deploy the buildbot master as a Docker service, with workers being
spawned on demand and automatically load-balanced across the available swarm
nodes.

### Sample configuration

The [sample configuration](buildbot/master.cfg) provided with this image
demonstrates the use of different types of workers. The behaviour depends on
whether the Docker daemon is accessible from the container.

If the Docker daemon is not accessible from the container:

- If `WORKERNAME` and `WORKERPASS` are provided, `worker.Worker` is used. This
  allows a worker to connect to the master at port 9989 using the given
  credentials.
- Otherwise, `worker.LocalWorker` is used. This will run a worker on the same
  host and in the same process as the buildbot master.

If the Docker daemon is accessible from the container:

- If the daemon is configured as a manager node on a Docker Swarm,
  `DockerSwarmLatentWorker` from the
  [buildbot-docker-swarm-worker](https://pypi.org/project/buildbot-docker-swarm-worker/)
  plugin is used. This allows the master to spawn workers as swarm services on
  demand.
- Otherwise, `worker.DockerLatentWorker` is used. This allows the master to
  spawn workers as sibling containers on demand.

The sample build downloads the source tarball from buildbot's
[hello-world](https://github.com/buildbot/hello-world) repository and runs its
test suite. The build must be triggered explicitly using the _trigger_ button on
the builder page.

### Important options

This section outlines important options when starting the container explicitly
using `docker run`. Skip to the following sections if you're only interested in
running the container using Docker Compose or Docker Swarm.

1. [Reaping zombie processes](#reaping-zombie-processes)
2. [Exposing the web port](#exposing-the-web-port)
3. [Exposing the buildbot port](#exposing-the-buildbot-port)
4. [Configuring the buildbot URL](#configuring-the-buildbot-url)
5. [Using a named volume for program data](#using-a-named-volume-for-program-data)
6. [Bind-mounting the Docker daemon socket](#bind-mounting-the-docker-daemon-socket)
7. [User and group ID](#user-and-group-id)
8. [Configuring buildbot](#configuring-buildbot)
9. [Running builds in the master container](#running-builds-in-the-master-container)
10. [Running builds in worker containers](#running-builds-in-worker-containers)
11. [Spawning workers as sibling containers](#spawning-workers-as-sibling-containers)
12. [Spawning workers on a Docker Swarm cluster](#spawning-workers-on-a-docker-swarm-cluster)

#### Reaping zombie processes

```sh
$ docker run --init -d cjolowicz/buildbot
```

You should always pass the `--init` option to ensure zombie processes created by
builds are reaped during the lifetime of each container.

If your version of Docker does not support the `--init` option, you can use the
following simple `Dockerfile` to generate an image with
[tini](https://github.com/krallin/tini) installed:

```Dockerfile
FROM cjolowicz/buildbot
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "docker-entrypoint.sh"]
```

Then build the image with `docker build -t custom-buildbot .` and run it as
follows:

```sh
$ docker run -d custom-buildbot
```

#### Exposing the web port

```sh
$ docker run --init -p 8010:8010 -d cjolowicz/buildbot
```

When the container has started up, point your browser to http://localhost:8010
to access the web interface. This is not required if you provide access to the
web interface by other means, such as an `nginx` container running on the same
Docker network.

#### Exposing the buildbot port

```sh
$ docker run --init -p 9989:9989 -d cjolowicz/buildbot
```

Expose port 9989 to allow buildbot workers to access the master at this port on
the Docker host. This is not required if workers are run as containers on the
same Docker network.

#### Configuring the buildbot URL

```sh
$ docker run --init -e BUILDBOT_URL=http://some-buildbot-host/ -d cjolowicz/buildbot
```

Use the `BUILDBOT_URL` environment variable to configure the external URL at
which the web interface is accessed. If `BUILDBOT_URL` is unset or empty, it
defaults to `http://localhost:8010`.

An incorrect buildbot URL results in errors in the web interface, because
requests to the API violate the [Same Origin
Policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy).
An example would be the following message when triggering a build:

    "invalid origin"

#### Using a named volume for program data

```sh
$ docker run --init -v buildbot:/var/lib/buildbot -d cjolowicz/buildbot
```

Program data such as the buildbot database is stored in a volume mounted at
`/var/lib/buildbot` in the container. It is recommended to provide a named
volume to share this data between successive runs of the image.

#### Bind-mounting the Docker daemon socket

```sh
$ docker run --init -v /var/run/docker.sock:/var/run/docker.sock -d cjolowicz/buildbot
```

The master container can spawn workers as sibling containers on demand. These
containers are stopped and removed when the build is finished. This requires
that the Docker daemon socket is bind-mounted into the master container.

Note that this has important [security
implications](https://docs.docker.com/engine/security/security/). Essentially,
access to the Docker daemon socket implies root privileges on the Docker host.

#### User and group ID

On startup, the image drops privileges for the buildbot process using
[su-exec](https://github.com/ncopa/su-exec):

```sh
$ id
uid=1000(buildbot) gid=1000(buildbot) groups=1000(buildbot)
```

If the Docker daemon socket is bind-mounted into the container, the process runs
with the group ID of the socket owner instead.

#### Configuring buildbot

Buildbot is configured using the file `/etc/buildbot/master.cfg` in the
container. You can provide your own configuration by bind-mounting it onto this
location:

```sh
$ docker run --init -v /host/path/master.cfg:/etc/buildbot/master.cfg:ro -d cjolowicz/buildbot
```

This can also be accomplished more cleanly using a simple `Dockerfile`:

```Dockerfile
FROM cjolowicz/buildbot
COPY master.cfg /etc/buildbot/master.cfg
```

Then build the image with `docker build -t custom-buildbot .` and run it as
follows:

```sh
$ docker run -d custom-buildbot
```

#### Running builds in the master container

Builds can be run in the master container using `worker.LocalWorker` in the
buildbot configuration, as demonstrated by the sample
[master.cfg](buildbot/master.cfg).

Ensure that the master image has the required build toolchain installed. The
following Alpine packages are already installed:

- [build-base](https://pkgs.alpinelinux.org/package/v3.9/main/x86_64/build-base)
- [python3-dev](https://pkgs.alpinelinux.org/package/v3.9/main/x86_64/python3-dev)
- [openssl-dev](https://pkgs.alpinelinux.org/package/v3.9/main/x86_64/openssl-dev)

You can install additional tools using the
[apk](https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management) package
manager in your own `Dockerfile`. Note that Alpine uses
[musl](https://www.musl-libc.org/) instead of
[glibc](https://www.gnu.org/software/libc/).

#### Running builds in worker containers

Builds can be run in long-running sibling containers using `worker.Worker` in
the master configuration. Supply the master hostname, worker name, and worker
password to the worker container via environment variables:

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

See
[cjolowicz/buildbot-worker](https://hub.docker.com/r/cjolowicz/buildbot-worker)
for a collection of buildbot worker images for various platforms.

#### Spawning workers as sibling containers

The master container can spawn buildbot workers as sibling containers on demand
using `worker.DockerLatentWorker`. Unlike long-running worker containers,
on-demand workers are provided automatically with an environment that allows
them to connect back to the master.

This requires that the Docker daemon socket is bind-mounted into the master
container, as described [above](#bind-mounting-the-docker-daemon-socket).

#### Spawning workers on a Docker Swarm cluster

The master container can spawn buildbot workers as Docker Swarm services on
demand using `worker.DockerSwarmLatentWorker` from the
[buildbot-docker-swarm-worker](https://pypi.org/project/buildbot-docker-swarm-worker/)
plugin.

This requires that the buildbot master is started as a Docker service on the
manager node of the Docker Swarm, and that the Docker daemon socket is
bind-mounted into the master container.

Consider using the provided [buildbot.yml](buildbot.yml) to deploy a Docker
stack with sensible defaults. See below for details.

### Use with Docker Compose

Use the supplied [docker-compose.yml](docker-compose.yml) file to start the
master container with sensible defaults:

```shell
$ docker-compose up -d
```

### Use with Docker Swarm

Use the supplied [buildbot.yml](buildbot.yml) file to start the master container
as a service on Docker Swarm:

```shell
$ eval $(./buildbot-env.sh)
$ docker stack deploy -c buildbot.yml buildbot
```

The script [buildbot-env.sh](buildbot-env.sh) prints shell commands to set up
environment variables for buildbot deployment. The output of this script should
be evaluated by the calling shell, as shown above. This is required after every
change to `master.cfg`, for the new configuration to get deployed to the stack.

If `DOCKER_HOST` is set in the environment, its value is used to provide a
default for `BUILDBOT_URL`.

## Building the Docker image

Building the Docker image requires [GNU
make](https://www.gnu.org/software/make/).

Here is a list of available targets:

| Target       | Description                         |
| ---          | ---                                 |
| `make build` | Build the image.                    |
| `make push`  | Upload the image to Docker Hub.     |
| `make pull`  | Download the image from Docker Hub. |
| `make login` | Log into Docker Hub.                |

Pass `NAMESPACE` to prefix the image with a Docker Hub namespace. The default is
`DOCKER_USERNAME`.

The `login` target is provided for non-interactive use and looks for
`DOCKER_USERNAME` and `DOCKER_PASSWORD`.

## Related projects

- https://github.com/cjolowicz/buildbot-docker-swarm-worker
- https://github.com/cjolowicz/docker-buildbot-worker
