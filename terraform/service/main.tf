//resource "aws_security_group" "public_https" {
//  name = "public_https_sg"
//  description = "Allow HTTPS traffic from public"
//  vpc_id = "${data.terraform_remote_state.shared.vpc_id}"
//}
//
//resource "aws_security_group_rule" "public_https" {
//  type = "ingress"
//  from_port = 443
//  to_port = 443
//  protocol = "tcp"
//  security_group_id = "${aws_security_group.public_https.id}"
//  cidr_blocks = ["0.0.0.0/0"]
//}

resource "aws_alb" "alb" {
  name = "alb-myapp"
  internal = false
  security_groups = [
    "${data.terraform_remote_state.shared.vpc_sg_id}"
//    "${aws_security_group.public_https.id}"
  ]
  subnets = ["${data.terraform_remote_state.shared.public_subnets_ids}"]
}

resource "aws_alb_target_group" "dafault" {
  name = "tg-myapp"
  port = "5000"
  protocol = "HTTP"
  vpc_id = "${data.terraform_remote_state.shared.vpc_id}"
  depends_on = ["aws_alb.alb"]

  stickiness {
    type = "lb_cookie"
  }
}

resource "aws_alb_listener" "http" {
  "default_action" {
    target_group_arn = "${aws_alb_target_group.dafault.arn}"
    type = "forward"
  }
  load_balancer_arn = "${aws_alb.alb.arn}"
  port = "5000"
  protocol = "HTTP"
}

data "template_file" "task_def" {
  template = "${file("${path.module}/task-definition.json")}"

  vars {

  }
}

resource "aws_ecs_task_definition" "task_definition" {
  container_definitions = "${data.template_file.task_def.rendered}"
  network_mode = "bridge"
  family = "ssr_web"
}

resource "aws_ecs_service" "service" {
  name = "ssr_web"
  cluster = "${data.terraform_remote_state.shared.ecs_cluster_name}"
  desired_count = "${length(data.terraform_remote_state.shared.aws_zones)}"
  iam_role = "${data.terraform_remote_state.shared.ecs_service_role_arn}"
  deployment_maximum_percent = "200"
  deployment_minimum_healthy_percent = "50"

  ordered_placement_strategy {
    type = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.dafault.arn}"
    container_name = "ssr_web"
    container_port = 5000
  }

  task_definition = "${aws_ecs_task_definition.task_definition.family}:${aws_ecs_task_definition.task_definition.revision}"
}
