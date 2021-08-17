variable "aws_region" {
    description = "The region we are going to use"
    default = "eu-west-1"
}

variable "ec2name" {
    description = "This will be the the variable for the EC2 name instance"
    default = "web-server-1"  
}

variable "httpport" {
  description = "the port we are going to use for the web server"
  default  = "8080"
}

variable "outputtext" {
 description = "what will be printed for the server"
 default = "Hello World"
}

variable "sgname" {
  description = "Security Group Name"
  default = "webserverexample"
}