#!/bin/bash

set -e

cd "$(dirname $0)/../.."

docker build -t beefweb-dev .
