resource "aws_security_group" "my_sg" {
  name        = "Gitlab"
  description = "Allow"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}
/*
resource "aws_security_group_rule" "gitlab-sg-self" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
 protocol          = "tcp"
  self              = true
 security_group_id = "aws_security_group.my-sg.id"
}
*/

