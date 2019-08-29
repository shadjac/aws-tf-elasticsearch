#!/bin/bash
DEBIAN_FRONTEND=noninteractive apt-get autoremove
sudo bash -c "echo "LC_CTYPE="en_US.UTF-8"" >> /etc/environment"
sudo bash -c "echo "LC_ALL="en_US.UTF-8"" >> /etc/environment"
source /etc/environment
sudo apt-get update
sudo apt-get install default-jre  -y
sudo apt-get install awscli -y
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update
sudo apt-get install elasticsearch
sudo bash -c "echo "JAVA_HOME="/usr"" >> /etc/environment"
source /etc/environment
mkdir /etc/elasticsearch/certs
sudo mkdir /etc/systemd/system/elasticsearch.service.d
sudo aws s3 cp s3://elasticsearch-config-files/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml --region ap-south-1
sudo aws s3 cp s3://elasticsearch-config-files/elasticsearch /etc/default/elasticsearch --region ap-south-1
sudo aws s3 cp s3://elasticsearch-config-files/limits.conf /etc/security/limits.conf --region ap-south-1
sudo aws s3 cp s3://elasticsearch-config-files/jvm.options /etc/elasticsearch/jvm.options --region ap-south-1
sudo aws s3 cp s3://elasticsearch-config-files/users_roles /etc/elasticsearch/users_roles --region ap-south-1
sudo aws s3 cp s3://elasticsearch-config-files/users /etc/elasticsearch/users --region ap-south-1
sudo aws s3 cp s3://elasticsearch-config-files/override.conf /etc/systemd/system/elasticsearch.service.d/override.conf --region ap-south-1

sudo aws s3 cp s3://elasticsearch-config-files/new-certs/dev.key /etc/elasticsearch/certs/dev.key --region ap-south-1
sudo aws s3 cp s3://elasticsearch-config-files/new-certs/myCA.pem /etc/elasticsearch/certs/myCA.pem --region ap-south-1
sudo aws s3 cp s3://elasticsearch-config-files/new-certs/dev.crt /etc/elasticsearch/certs/dev.crt --region ap-south-1

sudo chown elasticsearch:elasticsearch -R /etc/elasticsearch
id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
sudo sed -i "s/%NODENAME%/$id/g" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s/%INITIALMASTER%/$ip/g" /etc/elasticsearch/elasticsearch.yml
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-ec2 --batch
sudo update-rc.d elasticsearch defaults 95 10
sudo -i service elasticsearch start
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
