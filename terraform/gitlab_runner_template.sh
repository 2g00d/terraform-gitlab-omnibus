#!/bin/bash

yum update -y
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
usermod -a -G docker gitlab-runner