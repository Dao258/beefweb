#!/bin/bash

set -e

cd "$(dirname $0)/../.."

function banner
{
    echo
    echo ">> $1 <<"
    echo
}

export BEEFWEB_TEST_BUILD_TYPE=release
export BEEFWEB_USE_BEAST=1

banner 'Running server tests'
server/build/release/src/tests/core_tests

banner 'Running API tests'
(cd js/api_tests; yarn test)
