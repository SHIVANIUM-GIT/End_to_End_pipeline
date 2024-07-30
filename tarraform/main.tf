provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "Update with your AMI ID" 
  instance_type = "t2.micro"

  tags = {
    Name = "web-instance"
  }
}
