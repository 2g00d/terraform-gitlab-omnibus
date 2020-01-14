#!/bin/bash

yum update -y
yum install python3 -y
yum install git -y
pip3 install boto3 
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user


cat <<EOF > /opt/get_parameter.py
#!/bin/python3
import boto3
import fileinput
import os


ssm = boto3.client('ssm')
parameter = ssm.get_parameter(Name='/gitlab-runner-token', WithDecryption=False)
token = (parameter['Parameter']['Value'])

ip=(os.environ['GITLAB_IP'])

def replace_text(filename, text_to_search, replacement_text):
    with fileinput.FileInput(filename, inplace=True, backup='.bak') as file:
        for line in file:
            print(line.replace(text_to_search, replacement_text), end='')

replacement_text('/etc/gitlab-runner/config.toml', 'replace_ip', ip)
replacement_text('/etc/gitlab-runner/config.toml', 'replace_token', token)
EOF

chmod +x /opt/get_parameter.py


curl -o /home/ec2-user/gitlab-runner_amd64.rpm -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_amd64.rpm

rpm -i /home/ec2-user/gitlab-runner_amd64.rpm

gitlab-runner stop

cat << EOF > /etc/gitlab-runner/config.toml 
concurrent = 1
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "runner"
  url = "replace_ip"
  token = "replace_token"
  executor = "docker"
  [runners.custom_build_dir]
  [runners.docker]
    tls_verify = false
    image = "python:latest"
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache"]
    shm_size = 0
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
EOF

usermod -a -G docker gitlab-runner

systemctl start crond

cat <<EOF >> /etc/crontab
GITLAB_IP=${gitlab_ip}

*/3 * * * * root python3 /opt/get_parameter.py
EOF


systemctl restart crond

gitlab-runner start