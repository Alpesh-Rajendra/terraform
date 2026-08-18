variable "ami_id" {
  type        = string

}

variable "inst_type" {
  type    = string
  default = "t3.micro"
  
}

variable "key_pair" {
  type    = string
  

}

variable "subnet_id" {
    type = string
}

variable "security_group_id" {
  type = string
}
