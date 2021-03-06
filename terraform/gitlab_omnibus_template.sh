#!/bin/bash

yum update -y
yum install -y policycoreutils-python

yum install python3 -y
yum install git -y
pip3 install boto3 
service postfix start
chkconfig postfix on

curl -o  /home/ec2-user/script.rpm.sh https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh 
chmod +x /home/ec2-user/script.rpm.sh

/home/ec2-user/script.rpm.sh

yum -y install gitlab-ee

EXTERNAL_URL="$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"

echo "gitlab_rails['monitoring_whitelist'] = ['0.0.0.0/0', '127.0.0.0/8', '192.168.0.1']" >> /etc/gitlab/gitlab.rb

gitlab-ctl reconfigure 

gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token" > /tmp/token


cat <<EOF > /opt/put_parameter.py
#!/bin/python3
import boto3

ssm = boto3.client('ssm', region_name='us-east-1')

f = open("/tmp/token", "r")
val = f.readline()
f.close

delete = ssm.delete_parameter(Name='gitlab-runner-token')

response = ssm.put_parameter(
    Name='gitlab-runner-token',
    Description='token for register gitlab-runner tokens ',
    Value= val,
    Type='String',
    Tier='Standard',
    Overwrite=True,
)
EOF

chmod +x /opt/put_parameter.py

python3 /opt/put_parameter.py