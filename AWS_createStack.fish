#!/usr/bin/env fish

# used for s3 sync
set CurrentFolder (basename $PWD)
set S3Bucketname "jprf-dev/CloudFormation"
set CloudFormationTemplateName "CloudFormation.yml"

# -> CF template replacement strings
set CFDescriptionName $CurrentFolder
set EC2BootstrapScript "bootstrap.bash"
set S3WorkingDir (echo -n {$S3Bucketname}"/"{$CurrentFolder})
# <- CF end

# local fs holding dev files, some files must be there, see later
set FolderFrom (
    echo -n $PWD
)
set FolderTo (
    echo -n "s3://"$S3Bucketname"/"$CurrentFolder
)
# yml file to be used
set templateFileUrl (
    echo -n "https://s3.eu-central-1.amazonaws.com/"$S3Bucketname"/"$CurrentFolder"/"$CloudFormationTemplateName
)


if test (count $argv) -eq 1
    # --> Create server  
    if test $argv[1] = "up"
        
        # -> setup CFtemplate file
        if [ -e $PWD/"template_"$CloudFormationTemplateName ]
            # source "$PWD/prepareCloudFormation.fish"
            # -> prepare CF file
            # rm $CloudFormationTemplateName 2> /dev/null
            cp "template_"$CloudFormationTemplateName $CloudFormationTemplateName

            sed -i "" -e "s;S3WorkingDir;$S3WorkingDir;g" $CloudFormationTemplateName
            sed -i "" -e "s;EC2BootstrapScript;$EC2BootstrapScript;g" $CloudFormationTemplateName
            sed -i "" -e "s;CFDescriptionName;$CFDescriptionName;g" $CloudFormationTemplateName
            sed -i "" -e "s;DnsSubdomainName;$CurrentFolder;g" $CloudFormationTemplateName
            # <- CF end
        else
            echo "template_$CloudFormationTemplateName file is missing"
            exit 0
        end
        # <- CFfile END

        # -> sync current workingfiles to s3
        aws s3 rm $FolderTo --recursive
        aws s3 cp \
            $FolderFrom $FolderTo \
            --recursive \
            --exclude "*.git/*" \
            --exclude "*.vscode/*"
        # <- sync END
        
        # start AWS stack
        aws cloudformation create-stack \
            --stack-name $CurrentFolder \
            --capabilities CAPABILITY_IAM \
            --template-url $templateFileUrl
        exit 1
    end
    # <-- create END

    # -> get ip an dns sourced to var
    if test $argv[1] = "connect"
        set PhysicalResourceId (aws cloudformation describe-stack-resource \
            --stack-name $CurrentFolder \
            --logical-resource-id "myEC2Instance" \
            --output text \
            --query "StackResourceDetail.PhysicalResourceId")
        set DnsRecordName (aws cloudformation describe-stack-resource \
            --stack-name $CurrentFolder \
            --logical-resource-id "myDNSRecord" \
            --output text \
            --query "StackResourceDetail.PhysicalResourceId")
        set PublicDnsName (aws ec2 describe-instances \
            --instance-ids $PhysicalResourceId \
            --output text \
            --query "Reservations[0].Instances[0].PublicDnsName")
        echo -e "\nPhysicalResourceId:\n\t$PhysicalResourceId\n\nPublicDnsName:\n\t$PublicDnsName\n\nDnsRecordName:\n\t$DnsRecordName"
        # set sshAccessCommand "ssh -o \"StrictHostKeyChecking no\" ubuntu@\$PublicDnsName -i ~/.ssh/TMP_Win.pem" # ubuntu image
        set sshAccessCommand "ssh -o \"StrictHostKeyChecking no\" ec2-user@\$PublicDnsName -i ~/.ssh/TMP_Win.pem" # amazon linux image
        echo -e "ssh access via:\n\t$sshAccessCommand"
        exit 1
    end
    # <- ip/dns END    

    # --> destroy server
    if test $argv[1] = "down"
        aws cloudformation delete-stack \
            --stack-name $CurrentFolder
         set PhysicalResourceId ""
         set PublicDnsName ""
        exit 1
    end
    # <-- destroy END
end
echo "createStack.bash [up|down|connect]"