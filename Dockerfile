FROM debian:jessie-slim
MAINTAINER Joris Andrade <joris@frontapp.com>

RUN echo "deb http://repo.pritunl.com/stable/apt jessie main" > /etc/apt/sources.list.d/pritunl.list

# Pritunl Install
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A \
    && apt-get -y update \
    && apt-get -y install iptables pritunl \
    && rm -rf /var/lib/apt/lists/*

# Disable trying to edit sysctls since we manage these from Kubernetes
RUN sed -i -r 's/\bself\.enable_ip_forwarding\(/# &/' \
    /usr/lib/pritunl/lib/python2.7/site-packages/pritunl/server/instance.py

ADD rootfs /

EXPOSE 443
EXPOSE 10194
ENTRYPOINT ["/init"]
