data "template_file" "gitlab_omnibus_template" {
  template = "${file("${path.module}/gitlab_omnibus_template.sh")}"

}

data "template_file" "gitlab_runner_template" {
  template = "${file("${path.module}/gitlab_runner_template.sh")}"

 vars = {
    gitlab_ip = aws_instance.gitlab-omnibus.public_ip
  }

}

