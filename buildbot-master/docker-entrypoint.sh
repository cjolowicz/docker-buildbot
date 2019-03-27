#!/bin/sh

set -e

buildbot upgrade-master .

if [ ! -S /var/run/docker.sock ]
then
    echo "/var/run/docker.sock not found" >&2
    exit 1
fi

gid=$(stat -c '%g' /var/run/docker.sock)

adduser -h /var/lib/buildbot -D buildbot
chown -R buildbot /var/lib/buildbot

su-exec buildbot:$gid "$@"
