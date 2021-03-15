# [drseussfreak/bind](https://hub.docker.com/r/evanrich/bind)
This is a fork of eafxx's bind image.  It hadn't been updated in quite some time, and the ubuntu release it was based on (19.10) has EOL'd.   This is an updated image, rebased to Ubuntu 20.04.2, the latest bind and the latest version of webmin (1.973).   Contributions welcomed, I will try to keep this updated as necessary.
 
# Dev branch- use master only

## Contents
- [Introduction](#introduction)
  - [Installation](#installation)
  - [Quickstart](#quickstart)

# Introduction

Docker container image for [BIND](https://www.isc.org/downloads/bind/) DNS server bundled with the [Webmin](http://www.webmin.com/) interface.

BIND is open source software that implements the Domain Name System (DNS) protocols for the Internet. It is a reference implementation of those protocols, but it is also production-grade software, suitable for use in high-volume and high-reliability applications.

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/drseussfreak/bind) and is the recommended method of installation.

## Quickstart

Docker Run:

```bash
docker run --name bind -d --restart=always \
  -p serverip:53:53/tcp -p serverip:53:53/udp -p 10000:10000/tcp \
  -v /path/to/bind/data:/data \
  drseussfreak/bind
```

OR

Docker Compose

```
    bind:
        container_name: bind
        hostname: bind
        network_mode: bridge
        image: drseussfreak/bind
        restart: unless-stopped
        ports:
            - serverip:53:53/tcp
            - serverip:53:53/udp
            - 10000:10000/tcp
        volumes:
            - /path/to/bind/data:/data
        environment:
            - WEBMIN_ENABLED=true
            - WEBMIN_INIT_SSL_ENABLED=false
            - WEBMIN_INIT_REFERERS=dns.domain.com
            - WEBMIN_INIT_REDIRECT_PORT=10000
            - ROOT_PASSWORD=password
            - TZ=America/Chicago
```

When the container is started the [Webmin](http://www.webmin.com/) service is also started and is accessible from the web browser at https://serverIP:10000. Login to Webmin with the username `root` and password `password`. Specify `--env ROOT_PASSWORD=secretpassword` on the `docker run` command to set a password of your choosing. The launch of Webmin can be disabled if not required. 

### - Parameters

Container images are configured using parameters passed at runtime (such as those above). 

| Parameter | Function |
| :----: | --- |
| `-p 53:53/tcp` `-p 53:53/udp` | DNS TCP/UDP port|
| `-p 10000/tcp` | Webmin port |
| `-e WEBMIN_ENABLED=true` | Enable/Disable Webmin (true/false) |
| `-e ROOT_PASSWORD=password` | Set a password for Webmin root. Parameter has no effect when the launch of Webmin is disabled.  |
| `-e WEBMIN_INIT_SSL_ENABLED=false` | Enable/Disable Webmin SSL (true/false). If Webmin should be served via SSL or not. Defaults to `true`. |
| `-e WEBMIN_INIT_REFERERS` | Enable/Disable Webmin SSL (true/false). Sets the allowed referrers to Webmin. Set this to your domain name of the reverse proxy. Example: `mywebmin.example.com`. Defaults to empty (no referrer)|
| `-e WEBMIN_INIT_REDIRECT_PORT` | The port Webmin is served from. Set this to your reverse proxy port, such as `443`. Defaults to `10000`. |
| `-e BIND_EXTRA_FLAGS` | Default set to -g |
| `-v /data` | Mount data directory for persistent config  |
| `-e TZ=America/Chicago` | Specify a timezone to use e.g. America/Chicago |
