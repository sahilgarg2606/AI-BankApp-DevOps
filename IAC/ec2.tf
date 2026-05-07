#Region

provider "aws" {
  region="us-east-2"

}

#Key value pair
resource aws_key_pair my_key_pair {
  key_name   = "deployer-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7Mmmq8MJdeWQc/ppxg43cW4NB2DW6RvYbwVpE98vXK ubuntu@ip-172-31-47-20"
}


#vpc
resource aws_default_vpc default {

}

#security group
resource aws_security_group my_security{
  name = "terra-security-group"

  description = "Allow TLS inbound traffic and all outbound traffic"
}

#Inbound & Outbound port rules

resource aws_vpc_security_group_ingress_rule allow_http {
  security_group_id = aws_security_group.my_security.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource aws_vpc_security_group_egress_rule allow_all_traffic {
  security_group_id = aws_security_group.my_security.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "my_instance" {

     tags = {
    Name = "terra-auto"
  }
   ami = "ami-0fe18bc3cfa53a248"
   instance_type = "t3.micro"
   key_name = aws_key_pair.my_key_pair.key_name

    vpc_security_group_ids = [aws_security_group.my_security.id]
   root_block_device {

      volume_size = 10
      volume_type = "gp3"
   }
}