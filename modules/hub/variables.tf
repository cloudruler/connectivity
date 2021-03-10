variable "location" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_address_prefixes" {
  type = list(string)
}

variable "resource_group_name" {
  type = string
}

variable "name" {
  type = string
}
