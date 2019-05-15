variable "cidr_vpc" {
  default = "10.1.0.0/16"
  description = "CIDR block for the VPC"
}

variable "cidr_subnet" {
  default = "10.1.0.0/24"
  description = "CIDR block for the subnet"
}

variable "availability_zones" {
  type = "list"
  default = ["eu-west-2a", "eu-west-2b"]
  description = "availability zones to create subnets"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
  description = "Public key path"
}

variable "instance_type" {
  default = "t2.micro"
  description = "type of AWS EC2 instance"
}

variable "environment_tag" {
  default = "Production"
  description = "Environment tag"
}
