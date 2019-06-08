#!/bin/bash

oldversion=$(git describe --abbrev=0 | sed s/^v//)
version=$(sed -n "s/^VERSION = //p" Makefile)

if [ $version = $oldversion ]
then
    upstream=${version%-*}
    downstream=${version#*-}
    ((downstream++))
    version=$upstream-$downstream
    sed -i "s/$oldversion/$version/" Makefile
    git commit -am "Bump version to $version"
fi

git tag -m "Bump version to $version" v$version
