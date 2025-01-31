variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  default     = "ami-08c40ec9ead489470" # Amazon Linux 2 AMI (Check AWS for updates)
}

variable "ecr_name" {
  description = "Amazon ECR Repository Name"
  default     = "arpit-ecr-repo"
}

