resource "aws_key_pair" "ec2_key" {
  key_name = "ec2_public_key"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "vpc_ecs_test_instance" {
  ami = "${var.instance_ami}"
  instance_type = "${var.instance_type}"

  subnet_id = "${aws_subnet.pub_subnet.id}"
  vpc_security_group_ids = [
    "${aws_security_group.ecs_sec_group.id}"
  ]

  key_name = "${aws_key_pair.ec2_key.key_name}"

  tags {
    Name = "VPC ECS Test EC2"
    Environment = "${var.environment_tag}"
  }
}
