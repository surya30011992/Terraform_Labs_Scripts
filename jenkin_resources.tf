resource "aws_security_group" "jenkins_security_group" {
  name = "jenkins_security_group"
  vpc_id = var.instance_vpc_id
  ingress {
    description      = "http"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  } 
 }
resource "aws_instance" "jenkins_linux" {
   ami = var.instance_ami
   instance_type = var.instance_type
   key_name = var.instance_key
   vpc_security_group_ids = [ aws_security_group.jenkins_security_group.name ]
      tags = {
    name = "jenkins_linux"
     }
     user_data = file("jenkinsinstall.sh")
   }
