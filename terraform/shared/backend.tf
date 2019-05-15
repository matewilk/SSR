terraform {
  backend "s3" {
    bucket = "vpc-ecs-terraform-env"
    key = "shared/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
  }
}
