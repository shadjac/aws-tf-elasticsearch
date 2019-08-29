variable "region" {
  default = "ap-south-1"
}
variable "availability-zone" {
  default = "ap-south-1b"
}
variable "subnet-cidr" {
  default = "10.0.1.0/24"
}
variable "vpc-cidr" {
  default = "10.0.0.0/16"
}
variable "whitelist-cidr" {
  default = "103.101.70.203/32"
}
variable "ami-id" {
  default = "ami-03dcedc81ea3e7e27"
}
variable "es-node-count" {
  default = 1
}
variable "aws-pem-file-name" {
  default = "aws-technogise-free-tier"
}
