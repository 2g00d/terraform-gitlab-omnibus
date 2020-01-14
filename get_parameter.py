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