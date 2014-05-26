FROM ubuntu:14.04
MAINTAINER Simo Kinnunen

# Stop debconf from complaining about missing frontend
ENV DEBIAN_FRONTEND noninteractive

# Install node
RUN apt-get -y install wget && \
    wget --progress=dot:mega -O /opt/node.tar.gz \
      http://nodejs.org/dist/v0.10.28/node-v0.10.28-linux-x64.tar.gz && \
    tar -C /opt -xzf /opt/node.tar.gz && \
    rm /opt/node.tar.gz && \
    ln -s /opt/node-v0.10.28-linux-x64/bin/node /usr/local/bin/node && \
    ln -s /opt/node-v0.10.28-linux-x64/bin/npm /usr/local/bin/npm

# Clean up
RUN apt-get -y --purge remove wget && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/cache/apt/*

CMD ["/usr/local/bin/node"]
