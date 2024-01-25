variable "aws_region" {
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  default     = "10.0.2.0/24"
}

variable "ssh_ingress_cidr" {
  default     = ["0.0.0.0/0"]
}

variable "web_app_port" {
  default     = 3000
}

variable "instance_type" {
  default     = "t2.micro"
}

variable "ami_id" {
  default     = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2
}

variable "rds_mysql_port" {
  default     = 3306
}

variable "rds_allocated_storage" {
  default     = 20
}

variable "rds_instance_type" {
  default     = "db.t2.micro"
}

variable "rds_engine_version" {
  default     = "5.7"
}

variable "rds_username" {
  default     = "karim"
}

variable "rds_password" {
  default     = "karim"
}
