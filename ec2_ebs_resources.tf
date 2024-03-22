resource "aws_instance" "test_instances" {
    ami = var.instance_ami
    instance_type = var.instance_type
    key_name = var.instance_key
    count = 5
    tags = {
      Name = "test_server${count.index}"
    }
}

resource "aws_ebs_volume" "test_ebs" {
    availability_zone = var.zone
    size = 10
    count = 5
    tags = {
      Name = "test_vol${count.index}"
    }
}

