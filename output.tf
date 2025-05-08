output "name" {
    value = aws_instance.ansible_terraform_jenkinsinstance.id
  
}
output "sgid"{
    value = aws_security_group.ec2_sg_ssh_http.id
} 