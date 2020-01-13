variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_cidr_block" {
  type    = string
  default = "10.0.2.0/24"
}

variable "key" {
  type    = string
  default = "work"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "image_id" {
  type    = string
  default = "ami-062f7200baf2fa504"
}

variable "aws-region" {
  type    = string
  default = "us-east-1"
}

/*
variable "my-sg" {
  type    = string
  default = "sg-0599213b974bcb610"
}
*/


