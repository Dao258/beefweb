#!/bin/bash

set -e

cd "$(dirname $0)/../.."

docker build -t beefweb-main-dev -f docker-main
docker build -t beefweb-oldlibc-dev -f docker-oldlibc
