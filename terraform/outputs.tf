output "gitlab_ip" {
  description = ""
  value       = aws_instance.gitlab-omnibus.public_ip
}
output "gitlab_runner_1_ip" {
  description = ""
  value       = aws_instance.gitlab-runner-1.public_ip
}
output "gitlab_runner_2_ip" {
  description = ""
  value       = aws_instance.gitlab-runner-2.public_ip
}