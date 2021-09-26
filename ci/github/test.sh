#!/bin/bash

set -e

function banner
{
    echo
    echo ">> $1 <<"
    echo
}

function run_server_tests
{
    banner 'Running server tests'
    server/build/$BUILD_TYPE/src/tests/core_tests
}

function run_api_tests
{
    (
        banner "Running API tests on deadbeef $1"
        export BEEFWEB_TEST_DEADBEEF_VERSION=$1
        export BEEFWEB_TEST_BUILD_TYPE=$BUILD_TYPE
        tools/deadbeef/$1/deadbeef --version
        cd js/api_tests
        yarn test
    )
}

function main_outer
{
    docker run --rm -it \
        -e IN_DOCKER=1 -e BUILD_TYPE \
        -v $(pwd):/work:z \
        beefweb-dev \
        ci/github/test.sh
}

function main_inner
{
    run_server_tests
    run_api_tests v0.7
    run_api_tests v1.8
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
