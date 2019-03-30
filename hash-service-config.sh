#!/bin/bash

# config names must be maximum 64 characters in length
BUILDBOT_MASTER_CFG_HASH=$(sha256sum master.cfg | cut -c-16)

cat <<EOF
export BUILDBOT_MASTER_CFG_HASH=$BUILDBOT_MASTER_CFG_HASH
# Run this command to configure your shell:
# eval \$($0)
EOF
