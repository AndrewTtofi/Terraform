provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

# resource "aws_instance" "app_server" {
#   ami           = "ami-830c94e3"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "ExampleAppServerInstance"
# }
# }
