#!/bin/python3
import boto3
import requests
import time 
from requests import ReadTimeout, ConnectTimeout, HTTPError, Timeout, ConnectionError

ssm = boto3.client('ssm', region_name='us-east-1')

while True:
    try:
        resp = requests.get('http://34.201.210.240/-/health', timeout=10.0)
        if resp.status_code == 200:
            parameter = ssm.get_parameter(Name='/gitlab-runner-token', WithDecryption=False)
            token = (parameter['Parameter']['Value'])
            print ('Gitlab is up, writing token to file...')
            time.sleep(20)
            f = open('token','w')
            f.write(token)
            f.close()
    except (ConnectTimeout, HTTPError, ReadTimeout, Timeout, ConnectionError):
        print('Waiting for gitlab...')
        continue
