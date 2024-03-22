resource "aws_instance" "test_instances" {
    ami = var.instance_ami
    instance_type = var.instance_type
    key_name = var.instance_key
     tags = {
      Name = "test_server"
    }
}

resource "aws_ebs_volume" "test_ebs" {
    availability_zone = var.zone
    size = 10
    tags = {
      Name = "test_vol"
    }
}
 resource "aws_volume_attachment" "test" {
    instance_id = aws_instance.test_instances.id
    volume_id = aws_ebs_volume.test_ebs.id
    device_name = "/dev/sdh"
   
 }
