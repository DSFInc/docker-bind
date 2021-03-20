# [drseussfreak/bind](https://hub.docker.com/r/drseussfreak/bind)

![Webmin Logo](https://drseussfreak.github.io/images/tools/webmin.png?raw=true)

This is a fork of [sameersbn's](https://github.com/sameersbn/docker-bind) and [eafxx's](https://hub.docker.com/r/eafxx/bind) bind images.  [sameersbn's](https://github.com/sameersbn/docker-bind) had't been updated in a while, and [eafxx's](https://hub.docker.com/r/eafxx/bind) had put some recent work in to update bind and webmin.   This is running Ubuntu 20.04.02 with webmin 1.973.  I've also added the option to enble two-factor authentication into the image by default, so if you want to use it, the settings survive image updates.

If you have any problems or requests, please create an issue, and I will do my best to help.  Please bare with me, as this is my first image. 

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
  -p "53:53/tcp" -p "53:53/udp" -p 10000:10000/tcp \
  -v /path/to/bind/data:/data \
  drseussfreak/bind
```

OR

Docker Compose

```
version "3.8"
services:
    bind:
        container_name: bind
        hostname: bind
        network_mode: bridge
        image: drseussfreak/bind
        restart: unless-stopped
        ports:
            - "53:53/tcp"
            - "53:53/udp"
            - 10000:10000/tcp
        volumes:
            - /path/to/bind/data:/data
        environment:
            - WEBMIN_ENABLED=true
            - WEBMIN_INIT_SSL_ENABLED=false
            - WEBMIN_INIT_REFERERS=webmin1.domain.com webmin2.domain.com
            - WEBMIN_INIT_REDIRECT_PORT=10000
            - ROOT_PASSWORD=password
            - TZ=America/Chicago
```

When the container is started the [Webmin](http://www.webmin.com/) service is also started and is accessible from the web browser at https://serverIP:10000. Login to Webmin with the username `root` and password `password`. Specify `--env ROOT_PASSWORD=secretpassword` on the `docker run` command to set a password of your choosing. The launch of Webmin can be disabled if not required. 

### - Parameters

Container images are configured using parameters passed at runtime (such as those above). 

| Parameter | Function |
| :----: | --- |
| `-p "53:53/tcp"` `-p "53:53/udp" | DNS TCP/UDP port (you can also configure it as serverip:53:53 without the quotes)|
| `-p 10000:10000/tcp` | Webmin port |
| `-e WEBMIN_ENABLED=true` | Enable/Disable Webmin (true/false) |
| `-e ROOT_PASSWORD=password` | Set a password for Webmin root. Parameter has no effect when the launch of Webmin is disabled.  |
| `-e WEBMIN_INIT_SSL_ENABLED=false` | Enable/Disable Webmin SSL (true/false). If Webmin should be served via SSL or not. Defaults to `true`. |
| `-e WEBMIN_INIT_REFERERS` | Enable/Disable Webmin SSL (true/false). Sets the allowed referrers to Webmin. Set this to your domain name of the reverse proxy. Example: `mywebmin.example.com`. Defaults to empty (no referrer), for multuiple entires use a space delimeter|
| `-e WEBMIN_INIT_REDIRECT_PORT` | The port Webmin is served from. Set this to your reverse proxy port, such as `443`. Defaults to `10000`. |
| `-e BIND_EXTRA_FLAGS` | Default set to -g |
| `-v /data` | Mount data directory for persistent config  |
| `-e TZ=America/Chicago` | Specify a timezone to use e.g. America/Chicago |
