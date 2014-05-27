FROM ubuntu:14.04
MAINTAINER Simo Kinnunen

# Stop debconf from complaining about missing frontend
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update

# Fetch source
RUN apt-get -y install wget && \
    cd /tmp && \
    wget --progress=dot:mega \
      http://nodejs.org/dist/v0.10.28/node-v0.10.28.tar.gz && \
    apt-get -y --purge remove wget

# Compile and install (inspired by dockerfile/nodejs)
RUN cd /tmp && \
    apt-get -y install python build-essential && \
    tar xzf node-v*.tar.gz && \
    rm node-v*.tar.gz && \
    cd node-v* && \
    ./configure && \
    make && \
    make install && \
    rm -rf /tmp/node-v*

# Install development files for native modules so that npm install doesn't
# have to wait for them
RUN /usr/local/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js install

# Clean up
RUN apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/cache/apt/*

# Default command
CMD ["/usr/local/bin/node"]
