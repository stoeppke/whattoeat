#!/bin/bash

# publicHostname=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
publicHostname=$(echo -n $(curl -s http://169.254.169.254/latest/meta-data/instance-id).jprf-dev.de) #TODO set hostname by /tmp/DnsRecordName
# VIRTUAL_HOST_List=$(echo -n "www."$publicHostname","$publicHostname)
VIRTUAL_HOST_List=$(echo -n "www."$publicHostname)
# VIRTUAL_HOST_List_spaceSep=$(echo -n "www."$publicHostname" "$publicHostname)
VIRTUAL_HOST_List_spaceSep=$(echo -n "www."$publicHostname)
# publicHostname="myawstestdomain.chickenkiller.com"
publicIpv4=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
DockerPassword=$(openssl rand -base64 15)

cd /srv
git clone https://github.com/evertramos/docker-nextcloud-letsencrypt.git
cd docker-nextcloud-letsencrypt
cp .env.sample .env

# -> setting up .env file
    # -> comainion Host setup for this web-app
        sed -ie 's;VIRTUAL_HOST.*;\
        VIRTUAL_HOST='$VIRTUAL_HOST_List';' .env

        sed -ie 's;LETSENCRYPT_HOST.*;\
        LETSENCRYPT_HOST='$VIRTUAL_HOST_List';' .env

        sed -ie 's;your_email@yourdomain.com;stoeppke@gmail.com;g' .env
    # <- comanion END
    
    # special nextcloud stuff (hast to be space seperated)
        sed -ie 's/cloud,user,password/'${DockerPassword}'/g' .env
        sed -ie 's/ cloud,root,password/'${DockerPassword}'/g' .env
        sed -ie 's/admin,password/'${DockerPassword}'/g' .env   
        echo "NEXTCLOUD_TRUSTED_DOMAINS=${VIRTUAL_HOST_List_spaceSep}" >> .env
        sed -ie '/NEXTCLOUD_ADMIN_USER: \${NEXTCLOUD_ADMIN_USER}/a \
       NEXTCLOUD_TRUSTED_DOMAINS: \${NEXTCLOUD_TRUSTED_DOMAINS}' docker-compose.yml
        sed -ie 's;/home/user;\.;g' .env 
    # Nextcloud local data path on the server
# <- env end

docker-compose up -d

