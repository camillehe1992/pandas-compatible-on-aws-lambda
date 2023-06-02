#!/bin/sh

echo "Build a pandas deployment package for AWS Lambda layer"

DIR=$(pwd)
cd $DIR

ARCHITECTURE=$1
PYTHON_VERSION=$2

if [[ -z $ARCHITECTURE ]]; then
    echo 'Please provide the architecture (aarch64 or x86_64)'
    exit 1
else
    echo "architecture: $ARCHITECTURE"
fi

if [[ -z $PYTHON_VERSION ]]; then
    echo 'Please provide the python version (3.7 or 3.8 or 3.9)'
    exit 1
else
    echo "python version: $PYTHON_VERSION"
fi

PLATFORM=manylinux2014_$ARCHITECTURE
CP_VERSION=$(echo "$PYTHON_VERSION" | tr -d '.')
TARGET=./build/pandas_cp${CP_VERSION}_$PLATFORM

echo "zip file: $TARGET.zip"

DOCKER_IMAGE=public.ecr.aws/sam/build-python$PYTHON_VERSION

# install python dependencies on AWS Lambda base images
docker run -it --rm \
    -v "$PWD":/var/task \
    $DOCKER_IMAGE /bin/sh -c "./scripts/install-package.sh $PLATFORM $TARGET $PYTHON_VERSION"

# zip these dependencies
python3 scripts/zip.py $TARGET $TARGET.zip

exit
