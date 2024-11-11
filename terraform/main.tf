provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "app_instance" {
    ami           = "ami-0984f4b9e98be44bf" # Amazon Linux 2
    instance_type = "t2.micro"

    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -yum
                sudo amazon-linux-extras install docker -y
                sudo service docker start
                sudo usermod -a -G docker ec2-user_data
                docker run -d -p 80:5000 <imagem-docker>
                EOF
    tags = {
        Name = "devops-crud-instance"
    }
}

output "instance_public_ip" {
    value = aws_instance.app_instance.public_ip
}