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