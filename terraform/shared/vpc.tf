provider "aws" {
  region = "eu-west-2"
}

# VPC definition
resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_vpc}"

  tags {
    Name = "ecsVPC"
    Environment = "${var.environment_tag}"
  }
}

# Internet Gateway for the Public Subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "ecsIGW"
    Environment = "${var.environment_tag}"
  }
}

# Public Subnet
resource "aws_subnet" "pub_subnet" {
  count = "${length(var.availability_zones)}"

  cidr_block = "10.1.${(count.index + 1) * 10}.0/24"
  vpc_id = "${aws_vpc.vpc.id}"

  map_public_ip_on_launch = "true"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Name = "ecsPubSubnet-${element(var.availability_zones, count.index)}"
    Environment = "${var.environment_tag}"
  }
}

# Private Subnet
resource "aws_subnet" "priv_subnet" {
  count = "${length(var.availability_zones)}"

  cidr_block = "10.1.${(count.index + 1) * 11}.0/24"
  vpc_id = "${aws_vpc.vpc.id}"

  map_public_ip_on_launch = true
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Name = "ecsPrivSubnet-${element(var.availability_zones, count.index)}"
    Environment = "${var.environment_tag}"
  }
}

# Routing table for Public Subnet
resource "aws_route_table" "pub_subnet_routing_table" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "ecsPubSubnetRoutingTable"
    Environment = "${var.environment_tag}"
  }
}

# Associate the routing table with subnet (to make it public)
resource "aws_route_table_association" "pub_subnet_route_table_assoc" {
  route_table_id = "${aws_route_table.pub_subnet_routing_table.id}"
  subnet_id = "${element(aws_subnet.pub_subnet.*.id, count.index)}"
}

# VPC Security Group for instance
resource "aws_security_group" "vpc_sec_group" {
  name = "vpc_sec_group"
  description = "public access security group"

  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ecs public security group"
  }
}
