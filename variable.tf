variable "ami_id" {
  description = "ami id of ap-southeast-1"
  type        = string
  default     = "ami-05f071c65e32875a8"
}


variable "inst_type" {
  type    = string
  default = "t3.micro"
}

variable "key_pair" {
  type    = string
  default = "pankaj"

}
