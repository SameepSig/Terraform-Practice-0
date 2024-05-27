terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

# output "instance_id" {
#   description = "The ID of the AWS instance"
#   value       = aws_instance.sameep_terraform_ec2.id
# }