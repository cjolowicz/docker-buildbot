#!/bin/bash

make pull

if [ -z "$TRAVIS_TAG" ]
then
    make
else
    make push
fi
