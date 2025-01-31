output "ec2_public_ip" {
  value = aws_instance.web_instance.public_ip
}

output "ecr_repo_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}


