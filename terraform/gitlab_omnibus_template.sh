#!/bin/bash

yum update -y
yum install -y policycoreutils-python

service postfix start
chkconfig postfix on

curl -o  /home/ec2-user/script.rpm.sh https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh 
chmod +x /home/ec2-user/script.rpm.sh

/home/ec2-user/script.rpm.sh

yum -y install gitlab-ee

EXTERNAL_URL="$(curl  http://ip.tyk.nu/)"

gitlab-ctl reconfigure
