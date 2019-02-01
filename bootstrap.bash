#!/bin/bash
# works for amazon linux
yum update -y

# -> install docker(compose)
    yum install docker git -y
    service docker start
    usermod -a -G docker ec2-user
    sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    ln /usr/local/bin/docker-compose /usr/bin
# <- docker END

# -> fish & co install
    # --> install fish
        cd /etc/yum.repos.d/
        wget http://download.opensuse.org/repositories/shells:fish:release:2/CentOS_6/shells:fish:release:2.repo
        yum update -y
        yum install -y fish
        source ~/.bashrc
        sudo chsh -s /usr/bin/fish ec2-user
    # <-- fish end

    # --> personal fish components
        # su ec2-user
        cd /home/ec2-user


        sudo -u ec2-user bash -c \
            "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
        sudo -u ec2-user bash -c \
            "~/.fzf/install --all"

        # git clone https://github.com/garabik/grc.git
        # cd grc
        # ./install.sh
        # cd ../
        # rm -rf grc

        sudo -u ec2-user bash -c \
            "curl -L https://get.oh-my.fish > install"
        sudo -u ec2-user bash -c \
            "fish install --noninteractive --path=~/.local/share/omf --config=~/.config/omf"
        # fishomf reload
        # rm install
        sudo -u ec2-user bash -c \
            "curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish"
        sudo -u ec2-user fish -c 'fisher add barnybug/docker-fish-completion'
        sudo -u ec2-user fish -c 'omf install docker-machine fzf grc'
    # <-- end components
# <- fish end

# update dyndns myawstestdomain.chickenkiller.com
# curl "http://freedns.afraid.org/dynamic/update.php?aXd5SnR6Q252MXhmSENVdzFadm06MTc5NjAwNzY="
# echo '0,5,10,15,20,25,30,35,40,45,50,55 * * * * sleep 21 ; wget -O - "http://freedns.afraid.org/dynamic/update.php?aXd5SnR6Q252MXhmSENVdzFadm06MTc5NjAwNzY=" >> /tmp/freedns_myawstestdomain_chickenkiller_com.log 2>&1 &' >> /etc/crontab

source  "/tmp/docker-compose-letsencrypt-nginx-proxy-companion.bash"
sleep 10
source "/tmp/docker-nextcloud-letsencrypt.bash"