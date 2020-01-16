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
import time 
from requests import ReadTimeout, ConnectTimeout, HTTPError, Timeout, ConnectionError

ssm = boto3.client('ssm', region_name='us-east-1')

while True:
    try:
        resp = requests.get('http://${gitlab_ip}/-/health', timeout=3.0)
        if resp.status_code == 200:
            time.sleep(20)
            parameter = ssm.get_parameter(Name='/gitlab-runner-token', WithDecryption=False)
            token = (parameter['Parameter']['Value'])
            print ('Gitlab is up, writing token to file...')
            f = open('/opt/token','w')
            f.write(token)
            f.close()
            break
    except (ConnectTimeout, HTTPError, ReadTimeout, Timeout, ConnectionError):
        print('Waiting for gitlab...')
        time.sleep(20)
        continue
EOF

chmod +x /opt/get_parameter.py

curl -o /home/ec2-user/gitlab-runner_amd64.rpm -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_amd64.rpm
rpm -i /home/ec2-user/gitlab-runner_amd64.rpm

usermod -a -G docker gitlab-runner

python3 /opt/get_parameter.py 

TOKEN=$(cat /opt/token) 
echo $TOKEN
echo "export TOKEN=$TOKEN" >> /home/ec2-user/.bashrc
gitlab-runner register \
    --non-interactive \
    --url "http://${gitlab_ip}/" \
    --registration-token "$TOKEN" \
    --executor "docker" \
    --docker-image python:latest \
    --description "docker-runner" \
    --tag-list "docker" \
    --run-untagged="true" \
    --locked="false" \
    --access-level="not_protected"