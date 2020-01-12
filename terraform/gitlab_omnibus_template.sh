yum -y update
yum install -y curl policycoreutils-python openssh-server cronie
lokkit -s http -s ssh

yum install -y postfix
service postfix start
chkconfig postfix on

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash

