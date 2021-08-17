#This code deploys a simple web server in AWS. The web server always returns "Hello, World" on port 8080.
provider "AWS" {
  region = "${var.aws_region}"
}

resource "aws_instance" "ubuntu-server" {
   ami = "ami-0a8e758f5e873d1c1"
   instance_type = "t2.micro"
   availability_zone = "eu-west-1a"
   key_name = ""

   
}
