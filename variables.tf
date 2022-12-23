variable "aws_access_key" {
  type = string
  default = ""
}

variable "aws_secret_key" {
  type = string
  default = ""
}

variable "aws_region" {
  type = string
  default = "ap-southeast-2"
}

variable "tag_name" {
  type = string
  default = "PAT-demo-ecs-terraform"
}

variable "availability_zones" {
  type    = list(any)
  default = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "cidr_block" {
  type    = string
  default = "10.32.0.0/16"
}

variable "public_cidr_block" {
  type    = list(any)
  default = ["10.32.0.0/26", "10.32.1.0/26"]
}

variable "private_cidr_block" {
  type    = list(any)
  default = ["10.32.2.0/26", "10.32.3.0/26"]
}

variable "destination_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "cidr_block_route_table" {
  type    = string
  default = "0.0.0.0/0"
}

variable "app_count" {
  type = number
  default = 2
}

variable "min_capacity" {
  type = number
  default = 2
}
  
variable "max_capacity" {
  type = number
  default = 20
}

variable "target_value_request_count" {
  type = number
  default = 10
}

variable "cpu_capacity" {
  type = number
  default = 256
}

variable "memory_capacity" {
  type = number
  default = 1024
}
