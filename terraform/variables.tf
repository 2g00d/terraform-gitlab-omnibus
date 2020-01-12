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
  default = "work.pem"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "image_id" {
  type    = string
  default = ""
}
