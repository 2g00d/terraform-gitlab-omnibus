resource "aws_iam_role" "parameter_store" {
  name = "parameter_store"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "parameter_store_role"
  }
}

resource "aws_iam_instance_profile" "parameter_store_profile" {
  name = "parameter_store_profile"
  role = aws_iam_role.parameter_store.name
}

resource "aws_iam_role_policy" "parameter_store_policy" {
name = "parameter_store_policy"
role = aws_iam_role.parameter_store.id

policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": [
"ssm:PutParameter",
"ssm:DeleteParameter",
"ssm:GetParameter*"
],
"Resource": "*"
}
]
}
EOF

}