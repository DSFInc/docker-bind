# hadolint ignore=DL3007
FROM ubuntu:latest AS add-apt-repositories

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3005,DL3008,DL3008 
RUN apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wget sudo gnupg2 \
 && wget --no-check-certificate -q -O - http://www.webmin.com/jcameron-key.asc | apt-key add - \
 && echo "deb [trusted=yes] http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list

FROM ubuntu:latest
LABEL maintainer="drseussfreak"

ENV BIND_USER=bind \
    BIND_VERSION=9.16.1 \
    WEBMIN_VERSION=1.973 \
    DATA_DIR=/data \
    WEBMIN_INIT_SSL_ENABLED="" \
    TZ=""

COPY --from=add-apt-repositories /etc/apt/trusted.gpg.d /etc/apt/trusted.gpg.d/
COPY --from=add-apt-repositories /etc/apt/sources.list /etc/apt/sources.list

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3005,DL3008,DL3008 
RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      tzdata libauthen-oath-perl \
      bind9=1:${BIND_VERSION}* bind9-host=1:${BIND_VERSION}* dnsutils webmin \
#     webmin=${WEBMIN_VERSION}* \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named"]
