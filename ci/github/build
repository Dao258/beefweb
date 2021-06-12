#!/bin/bash

set -e

cd "$(dirname $0)/../.."

scripts/build.sh \
    --all --$BUILD_TYPE --tests --verbose \
    -DENABLE_WERROR=ON -DENABLE_STATIC_STDLIB=ON -DENABLE_GIT_REV=ON
