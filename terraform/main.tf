provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_instance" {
  ami           = "ami-0984f4b9e98be44bf" # Amazon Linux 2
  instance_type = "t2.micro"

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo amazon-linux-extras enable docker
                sudo amazon-linux-extras install docker -y
                sudo service docker start
                sudo usermod -a -G docker ec2-user

                # Instalar Docker Compose
                sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                sudo chmod +x /usr/local/bin/docker-compose

                # Instalar Git e clonar o repositório
                sudo yum install git -y
                git clone https://github.com/seu-usuario/seu-repositorio.git /home/ec2-user/app

                # Subir aplicação com Docker Compose
                cd /home/ec2-user/app
                docker-compose up -d
                EOF

  tags = {
    Name = "devops-crud-instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.app_instance.public_ip
}
