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