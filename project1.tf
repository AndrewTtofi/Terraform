#for referrence https://www.youtube.com/watch?v=SLB_c_ayRMo&t=1226s&ab_channel=freeCodeCamp.org

#Good to know note: whenever you change the region, the AMI ID changes as well
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
    #In order to delete the something you type in: terraform destroy
    