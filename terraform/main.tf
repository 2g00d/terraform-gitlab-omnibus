resource "aws_vpc" "my_vpc" {
  cidr_block = "${var.cidr_block}"

  tags = {
    Name = "gitlab-vpc"
  }
}

resource "aws_subnet" "my_public_subnet" {
  vpc_id                  = "${aws_vpc.my_vpc.id}"
  cidr_block              = "${var.public_subnet_cidr_block}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "gitlab-public-subnet"
  }
}

resource "aws_subnet" "my_private_subnet" {
  vpc_id            = "${aws_vpc.my_vpc.id}"
  cidr_block        = "${var.private_subnet_cidr_block}"
  availability_zone = "us-east-1b"

  tags = {
    Name = "gitlab-private-subnet"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = "${aws_vpc.my_vpc.id}"


}

resource "aws_route_table" "my_route_table" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_igw.id}"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.my_public_subnet.id}"
  route_table_id = "${aws_route_table.my_route_table.id}"
}

resource "aws_security_group" "my_sg" {
  name        = "Gitlab inbound"
  description = "Allow inbound"
  vpc_id      = "${aws_vpc.my_vpc.id}"

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

resource "aws_security_group_rule" "gitlab-sg-self" {
  type            = "ingress"
  self = true
  security_group_id = "aws_security_group.my-sg.id"
}
