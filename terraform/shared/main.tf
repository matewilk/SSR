// Generate user_data from template file
data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars {
    ecs_cluster_name = "${aws_ecs_cluster.ecs_cluster.name}"
  }
}

// Create Launch Configuration for EC2 instances
resource "aws_launch_configuration" "as_config" {
  image_id = "${data.aws_ami.ecs_instance_ami.id}"
  instance_type = "t2.micro"

  // this is default sec_group in the tutorial
  security_groups = ["${aws_security_group.vpc_sec_group.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance_profile.id}"

  root_block_device {
    volume_size = "8"
  }

  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

// Create Auto Scaling Group to add more hosts if necessary
resource "aws_autoscaling_group" "asg" {
  name = "asg_ecs_environment"
  // availability_zones = "${var.availability_zones}"
  vpc_zone_identifier = ["${aws_subnet.priv_subnet.*.id}"]
  max_size = 1
  min_size = 1
  desired_capacity = 1
  launch_configuration = "${aws_launch_configuration.as_config.id}"
  health_check_type = "EC2"
  health_check_grace_period = "120"
  default_cooldown = "30"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "ECS VPC EC2 Test Instance"
    propagate_at_launch = true
  }
}
