#https://www.youtube.com/watch?v=SLB_c_ayRMo&t=1226s
#The video explains on how to create a web server that has access to the internet and all will be configured via Terraform
#There are 9 steps in order to create our web app
# 1.Create a VPC
# 2. Create an Internet Gateway - in order to give public access to our resources
# 3. Crea Custom Route Table
# 4. Create a Subnet
# 5. Associate a subnet with a Route Table
# 6. Create a Security Group to allow port 22, 80 , 443
# 7. Create a network interface with an IP in the subnet that was created in step 4
# 8. Assign an elastic IP to the network interface created in step 7\
# 9. Create Ubuntu server and install/enable apache2


# provider "aws" {
#   profile = "default"
#   region  = "eu-west-1"
# }
#1 VPC
resource "aws_vpc" "first-project" {
  cidr_block       = "10.2.0.0/16"
  tags = {
    Name = "FirstProject"
  }

}
#2 Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.first-project.id

  tags = {
    Name = "GatewaytoNetP1"  
  }
}
#3 Route Table
resource "aws_route_table" "routetablep1" {
  vpc_id = aws_vpc.first-project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "routetableproject1"
  }
}

#4 Subnet
resource "aws_subnet" "subnetp1" {
    vpc_id = aws_vpc.first-project.id
    cidr_block = "10.2.1.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      "Name" = "subnetp1"
    }
}

#5 Assosiate Subnet with Route Table
resource "aws_route_table_association" "rttosubnet" {
  subnet_id = aws_subnet.subnetp1.id
  route_table_id = aws_route_table.routetablep1.id
}

#6 Create a Security Group
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.first-project.id

  ingress {  #this policy is used for https traffic
    description      = "HTTPS Traffic"
    from_port        = 443      #If from_port and to_port are the same the the access is only allowed on that specific port
    to_port          = 443
    protocol         = "tcp"  #Protocols that are going to be used on the security group
    cidr_blocks      = ["0.0.0.0/0" ]  #This is the IPs that are allowed to access the resource
  }
ingress {  #this policy is used for http traffic
    description      = "HTTP Traffic"
    from_port        = 80      #If from_port and to_port are the same the the access is only allowed on that specific port
    to_port          = 80
    protocol         = "tcp"  #Protocols that are going to be used on the security group
    cidr_blocks      = ["0.0.0.0/0" ]  #This is the IPs that are allowed to access the resource
  }
 ingress {  #this policy is used for ssh access
    description      = "SSH Access"
    from_port        = 22      #If from_port and to_port are the same the the access is only allowed on that specific port
    to_port          = 22
    protocol         = "tcp"  #Protocols that are going to be used on the security group
    cidr_blocks      = ["0.0.0.0/0" ]  #This is the IPs that are allowed to access the resource
  } 
  egress {  #
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all_web"
  }
}
#7 Network Interface
resource "aws_network_interface" "web_server_nic" {
  subnet_id       = aws_subnet.subnetp1.id
  private_ips     = ["10.2.1.50"]
  security_groups = [aws_security_group.allow_web.id]
  }

#8 Elastic IP
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web_server_nic.id
  associate_with_private_ip = "10.2.1.50"
  depends_on = [aws_internet_gateway.gw]
}

#9 Create Ubuntu Server
resource "aws_instance" "ubuntu_server" {
  ami = "ami-0a8e758f5e873d1c1"
  instance_type = "t2.micro"
  availability_zone = "eu-west-1a"
  key_name = "first-project"
  network_interface {
    network_interface_id = aws_network_interface.web_server_nic.id
    device_index = 0
  }

  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install apache2 -y
  sudo systemctl start apache2
  sudo bash -c 'echo your very first web server > /var/www/html/index.html'
  EOF

  tags = {
    "Name" = "WebServer"
  }
}

#Usefull Terraform commands to show the State of the Resources deployed or details of the Resource
  #terraform state  -> When you run this command a list of commands appears that helps us navigate throught the infrastructure
  #terraform state list -> Lists all the available resources in our infrastructure
  #terrafrom state show <resource> -> Shows details regarding the Resource we want to view