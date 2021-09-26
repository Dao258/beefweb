FROM ubuntu:20.04

RUN apt update && \
    apt upgrade -y && \
    apt install -y git g++ cmake nodejs yarnpkg

RUN cd /usr/bin && ln -s yarnpkg yarn

ENTRYPOINT /bin/bash
