#!/bin/bash

# config names must be maximum 64 characters in length
BUILDBOT_MASTER_CFG_HASH=$(sha256sum master.cfg | cut -c-16)

if [ -z "$BUILDBOT_URL" -a -n "$DOCKER_HOST" ]
then
    BUILDBOT_URL=http://${DOCKER_HOST#*://}
    BUILDBOT_URL=${BUILDBOT_URL%:*}:8010
    echo "export BUILDBOT_URL=$BUILDBOT_URL"
fi

cat <<EOF
export BUILDBOT_MASTER_CFG_HASH=$BUILDBOT_MASTER_CFG_HASH
# Run this command to configure your shell:
# eval \$($0)
EOF
