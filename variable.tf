variable ami {
    description = "default ami"
    default = "ami-04b70fa74e45c3917"
}

variable "instance_type" {
  description = "instance type"
  default = "t2.micro"
}

variable "key_name" {
    description = "default keypair"
    default = "Sameep-key-pair"
}