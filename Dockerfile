FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt upgrade -y && \
    apt install -y \
        tzdata build-essential file curl git cmake nodejs yarnpkg zlib1g-dev

RUN cd /usr/bin && ln -s yarnpkg yarn

WORKDIR /work

CMD ["/bin/bash"]
