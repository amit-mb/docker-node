FROM ubuntu:14.04
MAINTAINER Simo Kinnunen

# Trying to optimize push speed for dependant apps by reducing layers as
# much as possible. Note that one of the final steps installs development
# files for node-gyp so that npm install won't have to wait for them on
# the first native module installation.
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install wget && \
    cd /tmp && \
    wget --progress=dot:mega \
      http://nodejs.org/dist/v0.12.2/node-v0.12.2.tar.gz && \
    cd /tmp && \
    apt-get -y install python build-essential ninja-build && \
    tar xzf node-v*.tar.gz && \
    rm node-v*.tar.gz && \
    cd node-v* && \
    export CXX="g++ -Wno-unused-local-typedefs" && \
    ./configure --ninja && \
    make && \
    make install && \
    rm -rf /tmp/node-v* && \
    cd /tmp && \
    /usr/local/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js install && \
    apt-get clean && \
    rm -rf /var/cache/apt/*

# Default command
CMD ["/usr/local/bin/node"]
