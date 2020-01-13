#!/usr/bin/python
import boto3

response = client.get_parameter(
    Name='string',
    WithDecryption=True|False
)