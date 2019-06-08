#!/bin/bash

if [ -z "$TRAVIS_TAG" ]
then
    BRANCH="$TRAVIS_BRANCH"
elif [[ "$TRAVIS_TAG" =~ ^v1\.8\. ]]
then
    BRANCH=1.8
else
    BRANCH=master
fi

make ci GIT_BRANCH="$BRANCH" GIT_TAG="$TRAVIS_TAG"
