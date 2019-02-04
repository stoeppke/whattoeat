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
    sudo chsh -s /bin/bash ec2-user
# <- fish end

# --> get asociated dns hostname
    REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}')
    INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    StackName=$(aws ec2 describe-instances \
        --instance-id $INSTANCE_ID \
        --query 'Reservations[*].Instances[*].Tags[?Key==`aws:cloudformation:stack-name`].Value' \
        --region $REGION \
        --output text)
    DnsRecordName=$(aws cloudformation describe-stack-resource \
            --stack-name $StackName \
            --logical-resource-id "myDNSRecord" \
            --output text \
            --region $REGION \
            --query "StackResourceDetail.PhysicalResourceId")
    echo -n $DnsRecordName > /tmp/DnsRecordName
# <-- hostname END

source  "/tmp/docker-compose-letsencrypt-nginx-proxy-companion.bash"
sleep 10
source "/tmp/docker-webapp.bash"