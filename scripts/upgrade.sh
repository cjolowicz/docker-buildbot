#!/bin/bash

version=$1
shift

oldversion=$(sed -n "s/^VERSION = //p" Makefile | cut -d- -f1)

sed -i "s/$oldversion-[0-9]*/$version-1/" Makefile

for file in docker/Dockerfile docker/master.cfg buildbot.yml docker-compose.yml
do
    sed -i "s/$oldversion/$version/" $file
done

sed -i "s/buildbot-$oldversion/buildbot-$version/" README.md

git commit -am "Upgrade to buildbot $version"
