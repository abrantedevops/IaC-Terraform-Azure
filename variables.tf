variable "prefix" {
  type = string
  description = "The prefix which should be used for all resources in this example"
  default = "empresaAbranteme"
}

variable "location" {
  type = string
  description = "The Azure Region in which all resources in this example should be created."
  default = "brazilsouth"
}

variable "administrator_login" {
  type = string
  description = "The username of the local administrator to be created."
  default = "abrantedevops"
}

variable "vm_size" {
  type = string
  description = "The size of the virtual machine."
  default = "Standard_B1ls"
}