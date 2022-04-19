variable "alarm_configs_ec2" {
  description = "The total configuration, List of Objects/Dictionary"
  default = [{}]
  type = any 
}

variable "instance" {
  description = "ec2 instance details"
  type        = any
  default = [{}]
}

variable "project" {
  description = "Project name"
  type        = string
}