
variable "azure_rg_name" {
  default = "rg-agents" 
  description = "Specify the name of the new resource group"
}

variable "azure_region" {
  default     = "eastus" 
  description = "The location/region where the resources are created."
}

variable "source_address_prefix" {
  default = "*"
  description = " Ip or subnet for example 192.168.1.10"
}

variable "username" {
  default = "azureAdmin"
  description = "User Name"
}

variable "password" {
  default = "P@ssw0rd1234!"
  description = "Password"
}

variable "vm_size" {
  default = "Standard_B2s"
  description = "Size of Vm"
}

variable "server_name" {
  default = "win-agent"
  description = "name of machine"
}

variable "environment_tag" {
  default = "Dev"
  
}

variable "azp_token" {
  default = "{Your_PAT_Token}"

}
variable "azp_url" {
  default = "{Your_Organization_URL}"

}
variable "azp_pool" {
  default = "{Your_Agent_Pool_Name}" #make sure to create pool on your organization
}

