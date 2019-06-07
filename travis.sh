#!/bin/bash

if [ -z "$TRAVIS_TAG" ]
then
    BRANCH="$TRAVIS_BRANCH"
else
    BRANCH=master
fi

make ci GIT_BRANCH="$BRANCH" GIT_TAG="$TRAVIS_TAG"
