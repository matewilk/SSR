variable "cidr_vpc" {
  default = "10.1.0.0/16"
  description = "CIDR block for the VPC"
}

variable "cidr_subnet" {
  default = "10.1.0.0/24"
  description = "CIDR block for the subnet"
}

variable "availability_zone" {
  default = "eu-west-2a"
  description = "availability zone to create subnet"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
  description = "Public key path"
}

variable "instance_ami" {
  default = "ami-016a20f0624bae8c5"
  description = "AMI for AWS EC2 instance"
}

variable "instance_type" {
  default = "t2.micro"
  description = "type of AWS EC2 instance"
}

variable "environment_tag" {
  default = "Production"
  description = "Environment tag"
}
