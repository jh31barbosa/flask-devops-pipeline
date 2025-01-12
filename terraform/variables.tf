variable "instance_type" {
    default = "t2.micro"
}

#Definição da variável do token GitHub para ser passada no Terraform
variable "github_token" {
  description = "GitHub Token for accessing private repositories"
  type        = string
  sensitive   = true
}