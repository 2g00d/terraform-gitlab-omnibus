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
ssm = boto3.client('ssm')
parameter = ssm.get_parameter(Name='/gitlab-runner-token', WithDecryption=False)
token = (parameter['Parameter']['Value'])

f = open("/tmp/token","w")
f.write(token) 
f.close() 
EOF

chmod +x /opt/get_parameter.py


curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_amd64.rpm

rpm -i gitlab-runner_amd64.rpm

gitlab-runner stop

cat << EOF > /etc/gitlab-runner/config.toml 
concurrent = 1
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "runner"
  url = "http://3.215.134.168/"
  token = "TQiSrehxjGvWK364izDS"
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

gitlab-runner start
