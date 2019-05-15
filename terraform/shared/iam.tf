// Use ranodom id in naming of roles to prevent collisions
// should other ECS clusters be created in the same AWS account
// using this code
resource "random_id" "code" {
  byte_length = 4
}

// ECS Instance IAM Instacne Role and Policy
resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs_instance_role-${random_id.code.hex}"
  assume_role_policy = <<EOF
{
 "Version": "2008-10-17",
 "Statement": [
   {
     "Sid": "",
     "Effect": "Allow",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Action": "sts:AssumeRole"
   }
 ]
}
EOF

}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name = "ecs_instance_role_policy-${random_id.code.hex}"
  role = "${aws_iam_role.ecs_instance_role.id}"
  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "ecs:CreateCluster",
       "ecs:DeregisterContainerInstance",
       "ecs:DiscoverPollEndpoint",
       "ecs:Poll",
       "ecs:RegisterContainerInstance",
       "ecs:StartTelemetrySession",
       "ecs:Submit*",
       "ecr:GetAuthorizationToken",
       "ecr:BatchCheckLayerAvailability",
       "ecr:GetDownloadUrlForLayer",
       "ecr:BatchGetImage",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "*"
   }
 ]
}
EOF

}

// ECS IAM Service Role and Policy
resource "aws_iam_role" "ecs_service_role" {
  name = "ecs_service_role-${random_id.code.hex}"
  assume_role_policy = <<EOF
{
 "Version": "2008-10-17",
 "Statement": [
   {
     "Sid": "",
     "Effect": "Allow",
     "Principal": {
       "Service": "ecs.amazonaws.com"
     },
     "Action": "sts:AssumeRole"
   }
 ]
}
EOF

}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name = "ecs_sercie_role_policy-${random_id.code.hex}"
  role = "${aws_iam_role.ecs_service_role.id}"
  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "ec2:AuthorizeSecurityGroupIngress",
       "ec2:Describe*",
       "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
       "elasticloadbalancing:DeregisterTargets",
       "elasticloadbalancing:Describe*",
       "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
       "elasticloadbalancing:RegisterTargets"
     ],
     "Resource": "*"
   }
 ]
}
EOF

}

// an instance profile
// container for an IAM role to pass role information
// to an EC2 when the instance starts
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs_instance_profile"
  role = "${aws_iam_role.ecs_instance_role.name}"
}
