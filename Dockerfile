FROM centos:latest
LABEL maintainer "DI GREGORIO Nicolas <ndigrego@ndg-consulting.tech>"

### Environment variables
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    KEYBOXVERSION='v2.90_00'

### Install Application
RUN yum upgrade -y && \
    yum install -y java-1.8.0-openjdk-headless wget && \
    wget http://sshkeybox.com/releases/keybox/keybox-jetty-$KEYBOXVERSION.tar.gz -O /tmp/keybox.tar.gz && \
    tar xzf /tmp/keybox.tar.gz -C /opt && \
    yum remove -y wget && \
    yum clean all && \
    rm -rf /tmp/* \
           /var/cache/yum/* \
           /var/tmp/*
    
# Expose volumes
VOLUME ["/db"]

# Expose ports
EXPOSE 8443

### Running User: not used, managed by docker-entrypoint.sh
#USER keybox

### Start keybox
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["keybox"]
