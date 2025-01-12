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
              
              # Clonando o repositório do GitHub contendo o docker-compose.yml
              cd /home/ec2-user
              echo "export GITHUB_TOKEN=${var.github_token}" >> /etc/environment
              git clone https://github.com/jh31barbosa/simple-crud-devops.git
              cd repositorio-do-seu-projeto
              
              # Garantir que o Docker Compose está instalado
              sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              
              # Subir os containers com Docker Compose
              docker-compose down
              docker-compose pull
              docker-compose up -d
              EOF

  tags = {
    Name = "devops-crud-instance"
  }
}


