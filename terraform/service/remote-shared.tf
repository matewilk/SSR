data "terraform_remote_state" "shared" {
  backend = "s3"

  config {
    bucket = "vpc-ecs-terraform-env"
    key = "shared/terraform.tfstate"
    region = "eu-west-2"
  }
}
