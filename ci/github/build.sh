#!/bin/bash

set -e

function main_inner
{
    scripts/build.sh --all --$BUILD_TYPE --tests --verbose \
        -DENABLE_WERROR=ON -DENABLE_STATIC_STDLIB=ON -DENABLE_GIT_REV=ON
}

function main_outer
{
    docker run --rm -it \
        -e IN_DOCKER=1 -e BUILD_TYPE \
        -v $(pwd):/work:z \
        beefweb-dev \
        scripts/github/build.sh
}

cd "$(dirname $0)/../.."

if [ -z "$BUILD_TYPE" ]; then
    echo BUILD_TYPE is required
    exit 1
fi

if [ "$IN_DOCKER" == "1" ]; then
    main_inner
else
    main_outer
fi
