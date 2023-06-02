#!/bin/sh

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/publish-layer-version.html

PACKAGE=$1

aws lambda publish-layer-version \
    --layer-name $PACKAGE \
    --description "My Python layer" \
    --license-info "MIT" \
    --zip-file fileb://build/$PACKAGE.zip \
    --compatible-runtimes python3.7 python3.8 python3.9
