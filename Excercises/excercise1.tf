#This code deploys a simple web server in AWS. The web server always returns "Hello, World" on port 8080.
provider "AWS" {
  region = "${var.aws_region}"
}

# resource "aws_vpc" "WebServer" {
#   cidr_block = "10.10.0.0/16"
#   tags = {
#     Name = "Excercise1WebServer"
#   }
# }



#Create the ec2 instance
resource "aws_instance" "ubuntu-server" {
   ami = "ami-0a8e758f5e873d1c1"
   instance_type = "t2.micro"
   availability_zone = "eu-west-1a"
   key_name = ""
   

}


#Create the security group
resource "aws_security_group" "sg_ex1_server1" {
    name = "${var.sgname}"
}

resource "aws_security_group_rule" "http_inbound" {
    type = "ingress"
    from_port = "${var.httpport}"
    to_port = "${var.httpport}"
    protocol = "tcp"
    security_group_id = "${aws_security_group.sg_ex1_server1.id}"
}

resource "aws_security_group_rule" "https_inbound" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = "${aws_security_group.sg_ex1_server1.id}"
  
}