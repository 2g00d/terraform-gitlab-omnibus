resource "aws_instance" "gitlab-omnibus" {
  ami                         = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.key
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.my_public_subnet.id
  security_groups             = [aws_security_group.my_sg.id]
  iam_instance_profile =  aws_iam_instance_profile.s3_profile.name

  user_data = data.template_file.gitlab_omnibus_template.rendered

  tags = {
    Name = "gitlab"

  }
}
resource "aws_instance" "gitlab-runner-1" {
  ami                         = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.key
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.my_public_subnet.id
  security_groups             = [aws_security_group.my_sg.id]
  iam_instance_profile =  aws_iam_instance_profile.s3_profile.name

  user_data = data.template_file.gitlab_runner_template.rendered

  tags = {
    Name = "gitlab-runner"

  }
}
resource "aws_instance" "gitlab-runner-2" {
  ami                         = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.key
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.my_public_subnet.id
  security_groups             = [aws_security_group.my_sg.id]
  iam_instance_profile =  aws_iam_instance_profile.s3_profile.name

  user_data = data.template_file.gitlab_runner_template.rendered

  tags = {
    Name = "gitlab-runner"

  }
}