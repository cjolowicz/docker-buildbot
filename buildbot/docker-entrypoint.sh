#!/bin/sh

set -e

buildbot upgrade-master .

exec "$@"
