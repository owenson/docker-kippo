FROM ubuntu:trusty
MAINTAINER Gareth Owenson <gareth.owenson@port.ac.uk>

RUN apt-get update \
  && apt-get -q -y install \
    git \
    openssl \
    python-dev \
    python-openssl \
    python-pyasn1 \
    python-twisted \
    nano \
    vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -d /kippo -s /bin/bash -m kippo -g sudo
RUN git clone -q --depth 1 https://github.com/desaster/kippo.git /kippo-app
RUN mv /kippo-app/kippo.cfg.dist /kippo-app/kippo.cfg
RUN chown kippo /kippo-app -R

ADD banner.txt /banner.txt
ADD kippo.cfg /kippo-app/kippo.cfg
ADD userdb.txt /kippo-app/data/userdb.txt

EXPOSE 2222
USER kippo
WORKDIR /kippo-app
CMD ["twistd", "--nodaemon", "-y", "kippo.tac", "--pidfile=kippo.pid"]
