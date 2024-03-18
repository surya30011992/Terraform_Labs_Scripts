resource "aws_instance" "WebServer_Linux" {
   ami = "ami-02d7fd1c2af6eead0"
   instance_type = "t2.micro"
   key_name = "EC2"
   vpc_security_group_ids = [ aws_security_group.WebServer.name ]
            tags = {
     Name = "WebServer"
     OS = "Linux"
          
     }
     user_data = file("script.sh")
     
}

resource "aws_security_group" "WebServer" {
  name        = "WebServer"
  description = "Allow ssh http rdp"
  vpc_id      = "vpc-021fe2a3484a75f30"

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
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
  ingress {
    description      = "rdp"
    from_port        = 3389
    to_port          = 3389
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

  tags = {
    Name = "WebServer"
  }
}


   
