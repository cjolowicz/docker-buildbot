#!/bin/sh

set -e

if [ ! -L master.cfg ]
then
    ln -s /etc/buildbot/master.cfg
fi

buildbot upgrade-master .

chown -R buildbot /var/lib/buildbot

if [ ! -S /var/run/docker.sock ]
then
    echo "/var/run/docker.sock not found" >&2
    exit 1
fi

gid=$(stat -c '%g' /var/run/docker.sock)

su-exec buildbot:$gid "$@"
