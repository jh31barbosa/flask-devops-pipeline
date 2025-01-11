provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_instance" {
  ami           = "ami-0984f4b9e98be44bf" # Amazon Linux 2
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -aG docker ec2-user
              docker run -d --name app-container -p 5000:5000 <dockerhub-username>/<image-name>:<tag>
              EOF

  tags = {
    Name = "devops-crud-instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.app_instance.public_ip
}
