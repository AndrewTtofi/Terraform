#for referrence https://www.youtube.com/watch?v=SLB_c_ayRMo&t=1226s&ab_channel=freeCodeCamp.org

#Good to know note: whenever you change the region, the AMI ID changes as well
provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}
resource "aws_instance" "first-virtual-machine" {
 ami           = "ami-0a8e758f5e873d1c1"
 instance_type = "t2.micro"

 tags = {   #tags are many key values e.g. name of machine
   "Name" = "UbuntuRename"
 }
}

#nice to notes for Terraform:
    #In order to "stage" all the changes that are going to be made to your aws infrastructure you can type the command: terraform plan
    #In order to apply all the changes on AWS infrastructure you can type the command: terraform apply
    #In order to modify or change something on your aws infrastructure you just simply add or remove from your code and hit: terraform apply
    #In order to delete the something you type in: terraform destroy (usually this is not run very often since its going to destroy everything)

resource "aws_vpc" "first-vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "Production"
  }

}
resource "aws_vpc" "second-vpc" {
  cidr_block       = "10.1.0.0/16"
  tags = {
    Name = "Developers"
  }

}
resource "aws_subnet" "subnet-1" {
  vpc_id     =  aws_vpc.first-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Production-Subnet"
  }
}
resource "aws_subnet" "subnet-2" {
  vpc_id     =  aws_vpc.second-vpc.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "Developers-Subnet"
  }
}

#The order that you write your code does not really matter since it takes it as a whole
  #e.g if we placed the subnet above the vpc it would still create the subnet under our vpc
