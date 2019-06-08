#!/bin/sh

set -e

buildbot upgrade-master .

chown -R buildbot /var/lib/buildbot

if [ -S /var/run/docker.sock ]
then
    group=$(stat -c '%g' /var/run/docker.sock)
else
    group=buildbot
fi

su-exec buildbot:$group "$@"
