# creating VPC surya_vpc
resource "aws_vpc" "surya_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "surya_vpc"
    }
  
}

#creating IGW surya_igw
resource "aws_internet_gateway" "surya_igw" {
    vpc_id = aws_vpc.surya_vpc.id
    depends_on = [ aws_vpc.surya_vpc ]

}

#creating public subnet 
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.surya_vpc.id
    depends_on = [ aws_vpc.surya_vpc ]
    availability_zone = "us-east-1a"
    cidr_block = "10.0.1.0/24"
    tags = {
      Name = "public_subnet"
    } 
}

#creating private subnet 
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.surya_vpc.id
    depends_on = [ aws_vpc.surya_vpc ]
    availability_zone = "us-east-1b"
    cidr_block = "10.0.2.0/24"
    tags = {
      Name = "private_subnet"
    }
}

#creating Public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.surya_vpc.id
  depends_on = [ aws_vpc.surya_vpc ]
  tags = {
    Name = "public_route_table"
  }
}

#creating Public route 
resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_route_table.id
  depends_on = [ aws_route_table.public_route_table , aws_internet_gateway.surya_igw ]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.surya_igw.id
}

#creating Public route table association
resource "aws_route_table_association" "public_route_table_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet.id

}

#creating EIP
resource "aws_eip" "nat_eip" {
    domain = "vpc" 
}

#creating NAT and assigning EIP
resource "aws_nat_gateway" "surya_nat" {
  subnet_id = aws_subnet.public_subnet.id 
  allocation_id = aws_eip.nat_eip.id
  tags = {
    Name = "surya_nat"
  }
}

#creating Private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.surya_vpc.id
  tags = {
    Name = "private_route_table"
  }
}

#creating Private route 
resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.surya_nat.id
  depends_on = [ aws_route_table.private_route_table , aws_nat_gateway.surya_nat ]
}

#creating private route association
resource "aws_route_table_association" "private_subnet_association" {
  route_table_id = aws_route_table.private_route_table.id
  depends_on = [ aws_route_table.private_route_table , aws_subnet.private_subnet , aws_route.private_route ]
  subnet_id = aws_subnet.private_subnet.id
}




