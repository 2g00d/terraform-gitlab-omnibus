import boto3
ssm = boto3.client('ssm')
parameter = ssm.get_parameter(Name='/test', WithDecryption=False)
print(parameter['Parameter']['Value'])