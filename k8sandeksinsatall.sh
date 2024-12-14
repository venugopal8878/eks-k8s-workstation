#!/bin/bash

USERID=$(id -u)
Time_stamp=$(date +%F-%H-%M-%S)
script_name=$(echo $0 | cut -d "." -f1)

Log_file=$script_name-$Time_stamp.log

R="\e[31m"
G="\e[32m"

    if [$USERID -ne 0]
    then
    echo -e "Please run the script with root user $R" 
    exit 1
    else
    echo "$G you are super user"
    fi

VALIDATE(){
    if [$1 -ne 0]
then 
echo "$2 is not exceute successfully $R please check"
else 
echo "$2 executed successfully $G"
fi 
}


ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

# docker
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
VALIDATE $? "Docker installation"

echo "eksctl installing"

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
mv /tmp/eksctl /usr/local/bin
eksctl version
VALIDATE $? "eksctl installation"


echo "kubctl installation started"

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.0/2024-09-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv kubectl /usr/local/bin/kubectl
version=$(kubectl version)
echo "ks version $version"


echo "kubens installing"
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens
VALIDATE $? "kubens installation"


 echp "Helm insatlling"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
 chmod 700 get_helm.sh
 ./get_helm.sh
 VALIDATE $? "helm installation"

echo "give AWS Credetial"

#aws configure