#!/bin/sh

PLATFORM=$1
TARGET=$2
PYTHON_VERSION=$3

rm -rf $TARGET

pip3 install \
    --platform $PLATFORM \
    --target $TARGET/python \
    --implementation cp \
    --python $PYTHON_VERSION \
    --only-binary=:all: --upgrade \
    pandas

exit
