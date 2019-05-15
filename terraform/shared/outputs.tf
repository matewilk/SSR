output "aws_zones" {
  value = ["${var.availability_zones}"]
}

output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.ecs_cluster.name}"
}

output "ecs_service_role_arn" {
  value = "${aws_iam_role.ecs_service_role.arn}"
}

output "private_subnets_ids" {
  value = "${aws_subnet.priv_subnet.*.id}"
}

output "public_subnets_ids" {
  value = "${aws_subnet.pub_subnet.*.id}"
}

output "vpc_sg_id" {
  value = "${aws_security_group.vpc_sec_group.id}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
