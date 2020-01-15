#!/bin/bash

yum update -y
yum install python3 -y
yum install git -y
pip3 install boto3 
pip3 install --upgrade requests
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user

echo "export GITLAB_IP=${gitlab_ip}" >>  /home/ec2-user/.bashrc

cat <<EOF > /opt/get_parameter.py
#!/bin/python3
import boto3
import requests

resp = requests.get('http://${gitlab_ip}/-/health')

while resp.status_code == 200:
    ssm = boto3.client('ssm', region_name='us-east-1')
    parameter = ssm.get_parameter(Name='/gitlab-runner-token', WithDecryption=False)
    token = (parameter['Parameter']['Value'])
    f = open('token','w')
    f.write(token)
    f.close()
    break
EOF

chmod +x /opt/get_parameter.py

curl -o /home/ec2-user/gitlab-runner_amd64.rpm -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_amd64.rpm
rpm -i /home/ec2-user/gitlab-runner_amd64.rpm

usermod -a -G docker gitlab-runner

cat <<EOF > /opt/runner.sh
#!/bin/bash
file="/opt/token" 
token=$(cat "$file")
echo $token >> /home/ec2-user/.bashrc

gitlab-runner register \
    --non-interactive \
    --url "http://${gitlab_ip}/" \
    --registration-token "$token" \
    --executor "docker" \
    --docker-image python:latest \
    --description "docker-runner" \
    --tag-list "docker,aws" \
    --run-untagged="true" \
    --locked="false" \
    --access-level="not_protected"
EOF

chmod +x /opt/runner.sh

python3 /opt/get_parameter.py && /opt/runner.sh