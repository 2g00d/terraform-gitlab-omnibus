import boto3

ssm = boto3.client('ssm')

f = open("/tmp/token", "r")
val = f.readline()
f.close

#name = input('Input parameter name here: ')
#val = input('Input your token here: ')

response = ssm.put_parameter(
    Name='gitlab-runner-token',
    Description='token for register gitlab-runner tokens ',
    Value= val,
    Type='String',
    Tier='Standard',
    Overwrite=True,
)