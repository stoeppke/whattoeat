#!/bin/bash

cd /srv
git clone https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion.git
cd docker-compose-letsencrypt-nginx-proxy-companion
cp .env.sample .env
bash -c "./start.sh"