FROM dsfinc/ubuntu AS add-apt-repositories

RUN apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wget sudo gnupg2 \
 && apt-key adv --fetch-keys http://www.webmin.com/jcameron-key.asc \
 && wget --no-check-certificate -q -O - http://www.webmin.com/jcameron-key.asc | apt-key add - \
 && echo "deb [trusted=yes] http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list \
 && apt-get update

FROM dsfinc/ubuntu
LABEL maintainer="DrSeussFreak"

ENV BIND_USER=bind \
    DATA_DIR=/data \
    WEBMIN_INIT_SSL_ENEABLE="" \
    TZ=""

COPY --from=add-apt-repositories /etc/apt/trusted.gpg.d /etc/apt/trusted.gpg.d
COPY --from=add-apt-repositories /etc/apt/sources.list /etc/apt/sources.list

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      libauthen-oath-perl bind9 bind9-host dnsutils webmin \
 && apt-get update \
 && apt-get upgrade -y \
 && rm -rf /var/lib/apt/lists/*

COPY tools/entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named"]
