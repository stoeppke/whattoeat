#!/bin/bash

# publicHostname=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
publicHostname=$(cat /tmp/DnsRecordName)
# VIRTUAL_HOST_List=$(echo -n "www."$publicHostname","$publicHostname)
VIRTUAL_HOST_List=$(echo -n "backend."$publicHostname)
VIRTUAL_HOST_List_frontend=$(echo -n ""$publicHostname)
# VIRTUAL_HOST_List_spaceSep=$(echo -n "www."$publicHostname" "$publicHostname)
VIRTUAL_HOST_List_spaceSep=$(echo -n "www."$publicHostname)
# publicHostname="myawstestdomain.chickenkiller.com"
publicIpv4=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
DockerPassword=$(openssl rand -base64 15)

cd /tmp
# cp .env.sample .env

# -> setting up .env file
    # -> comainion Host setup for this web-app
        sed -ie 's;VIRTUAL_HOST_frontend.*;\
        VIRTUAL_HOST_frontend='$VIRTUAL_HOST_List_frontend';' .env
        sed -ie 's;VIRTUAL_HOST_backend.*;https://'$VIRTUAL_HOST_backend';' index.html
        VIRTUAL_HOST='$VIRTUAL_HOST_List';' .env

        # sed -ie 's;LETSENCRYPT_HOST.*;\
        # LETSENCRYPT_HOST='$VIRTUAL_HOST_List';' .env

        sed -ie 's;your_email@yourdomain.com;stoeppke@gmail.com;g' .env
    # <- comanion END
# <- env end

docker-compose up -d

