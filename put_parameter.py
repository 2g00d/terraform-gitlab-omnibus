import boto3

ssm = boto3.client('ssm')

name = input('Input parameter name here: ')
val = input('Input your token here: ')

response = ssm.put_parameter(
    Name=name,
    Description='token for register gitlab-runner tokens ',
    Value= val,
    Type='String',
    Tier='Standard',
    #override
)