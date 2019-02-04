#!/bin/bash

publicHostname=$(cat /tmp/DnsRecordName)
VIRTUAL_HOST_backend=$(echo -n "backend."$publicHostname)
VIRTUAL_HOST_frontend=$(echo -n ""$publicHostname)
VIRTUAL_HOST_List_spaceSep=$(echo -n "www."$publicHostname)

publicIpv4=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

cd /tmp #TODO: move website stuff to /srv 

# -> setting up .env file
    # -> comainion Host setup for this web-app
        sed -ie 's;VIRTUAL_HOST_frontend.*;VIRTUAL_HOST_frontend='$VIRTUAL_HOST_frontend';' .env
        sed -ie 's;VIRTUAL_HOST_backend.*;VIRTUAL_HOST_backend='$VIRTUAL_HOST_backend';' .env
        sed -ie 's;VIRTUAL_HOST_backend;https://'$VIRTUAL_HOST_backend';' index.html

        sed -ie 's;your_email@yourdomain.com;stoeppke@gmail.com;g' .env
    # <- comanion END
# <- env end
sed -ie 

docker-compose up -d

