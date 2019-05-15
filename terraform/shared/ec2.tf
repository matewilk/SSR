//resource "aws_key_pair" "ec2_key" {
//  key_name = "ec2_public_key"
//  public_key = "${file(var.public_key_path)}"
//}
//
data "aws_ami" "ecs_instance_ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}
//
//resource "aws_instance" "vpc_ecs_test_instance" {
//  ami = "${data.aws_ami.ecs_instance_ami.id}"
//  instance_type = "${var.instance_type}"
//
//  subnet_id = "${element(aws_subnet.pub_subnet.*.id, count.index)}"
//  vpc_security_group_ids = [
//    "${aws_security_group.vpc_sec_group.id}"
//  ]
//
//  key_name = "${aws_key_pair.ec2_key.key_name}"
//
//  tags {
//    Name = "VPC ECS Test EC2"
//    Environment = "${var.environment_tag}"
//  }
//}
