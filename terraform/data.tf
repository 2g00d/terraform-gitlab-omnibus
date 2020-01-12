data "template_file" "gitlab_omnibus_template" {
  template = "${file("$./gitlab_omnibus_template.sh")}"
}

data "template_file" "gitlab_runner_template" {
  template = "${file("$./gitlab_runner_template.sh")}"
}