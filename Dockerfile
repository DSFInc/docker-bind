FROM ubuntu:latest AS add-apt-repositories

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y gnupg \
 && apt-key adv --fetch-keys http://www.webmin.com/jcameron-key.asc \
 && echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list

FROM ubuntu:latest
LABEL maintainer="DrSeussFreak"

ENV BIND_USER=bind \
    BIND_VERSION=9.16.1 \
    WEBMIN_VERSION=1.973 \
    DATA_DIR=/data \
    WEBMIN_INIT_SSL_ENEABLE="" \
    TZ=""

COPY --from=add-apt-repositories /etc/apt/trusted.gpg.d /etc/apt/trusted.gpg.d
COPY --from=add-apt-repositories /etc/apt/sources.list /etc/apt/sources.list

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      tzdata libauthen-oath-perl \
      bind9=1:${BIND_VERSION}* bind9-host=1:${BIND_VERSION}* dnsutils \
      webmin=${WEBMIN_VERSION}* \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named"]
