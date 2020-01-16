#!/bin/python3
import boto3
import requests
import time 
from requests import ReadTimeout, ConnectTimeout, HTTPError, Timeout, ConnectionError

ssm = boto3.client('ssm', region_name='us-east-1')

while True:
    try:
        resp = requests.get('http://3.80.160.126/-/health', timeout=3.0)
        if resp.status_code == 200:
            parameter = ssm.get_parameter(Name='/gitlab-runner-token', WithDecryption=False)
            token = (parameter['Parameter']['Value'])
            print ('Gitlab is up, writing token to file...')
            var_str='TOKEN='+token
            f = open('token','w')
            f.write(var_str)
            f.close()
            break
    except (ConnectTimeout, HTTPError, ReadTimeout, Timeout, ConnectionError):
        print('Waiting for gitlab...')
        time.sleep(20)
        continue