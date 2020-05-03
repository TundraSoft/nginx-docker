# TundraSoft - NGINX Docker

nginx [engine x] is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server, originally written by Igor Sysoev. For a long time, it has been running on many heavily loaded Russian sites including Yandex, Mail.Ru, VK, and Rambler. According to Netcraft, nginx served or proxied 25.54% busiest sites in April 2020. Here are some of the success stories: Dropbox, Netflix, Wordpress.com, FastMail.FM.

# Usage

You can run the docker image by

## docker run

```
docker run \
 --name=nginx \
 -p 80:80 \
 -e TZ=Europe/London \
 -v nginx_sites:/var/www \
 -v nginx_config:/etc/nginx \
 -v nginx_logs:/var/log/nginx \
 --restart unless-stopped \
 tundrasoft/nginx-docker:latest
```

## docker Create

```
docker run \
  --name=postgres \
  -p 80:80 \
  -e TZ=Europe/London \
  -v nginx_sites:/var/www \
  -v nginx_config:/etc/nginx \
  -v nginx_logs:/var/log/nginx \
  --restart unless-stopped \
  tundrasoft/nginx-docker:latest
```

## docker-compose

```
version: "3.2"
services:
  mariadb:
    image: tundrasoft/nginx-docker:latest
    ports:
      - 80:80
      - 443:443
    environment:
      - TZ=Asia/Kolkata # Specify a timezone to use EG Europe/London
    volumes:
      - nginx_sites:/var/www # Nginx www path
      - nginx_config:/etc/nginx # Path where configuration files for nginx exists
      - nginx_logs:/var/logs/nginx # Path where nginx logs will sit
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
```

## Ports

80 - The default web port
443 - SSL port

## Variables

### TZ

The timezone to use.

## Volumes

### Web Root - /var/www

The web root where nginx will serve all files.

### Config - /etc/nginx

Config files for nginx. Default config files would already be created and put in place.
There is a sub folder sites.d, in here place each site's configuraition with suffix .enabled.conf.
Sites with suffix other than .enabled.conf will not be loaded

### Logs - /var/logs/nginx

Path where log files will be present.
