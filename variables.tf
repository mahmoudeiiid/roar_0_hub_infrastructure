variable "region" {
  default = "us-east-2"
}
variable "instance_ami" {
  default = "ami-0022f774911c1d690"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "instance_tags" {
  default = var.additional_tags
}
variable "instance_key_pair" {
  default = "EidKeyPair"
}
variable "additional_tags" {
  default     = {owner-sso-username = "mahm1845",needed-until-date="2022-06-30",environment : "playground"}
  description = "Additional resource tags"
  type        = map(string)
}
variable "instance_role" {
  default = "Jenkins-cloudformation"
}