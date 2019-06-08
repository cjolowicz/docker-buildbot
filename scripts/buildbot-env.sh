#!/bin/bash

shell=$(basename $SHELL)

# config names must be maximum 64 characters in length
BUILDBOT_MASTER_CFG_HASH=$(sha256sum buildbot/master.cfg | cut -c-16)

if [ -z "$BUILDBOT_URL" -a -n "$DOCKER_HOST" ]
then
    BUILDBOT_URL=http://${DOCKER_HOST#*://}
    BUILDBOT_URL=${BUILDBOT_URL%:*}:8010/
    if [ $shell = fish ]
    then
        echo "set -gx BUILDBOT_URL $BUILDBOT_URL;"
    else
        echo "export BUILDBOT_URL=$BUILDBOT_URL"
    fi
fi

if [ $shell = fish ]
then
    cat <<EOF
set -gx BUILDBOT_MASTER_CFG_HASH $BUILDBOT_MASTER_CFG_HASH;
# Run this command to configure your shell:
# eval ($0)
EOF
else
    cat <<EOF
export BUILDBOT_MASTER_CFG_HASH=$BUILDBOT_MASTER_CFG_HASH
# Run this command to configure your shell:
# eval \$($0)
EOF
fi
