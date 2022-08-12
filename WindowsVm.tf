
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "random_string" "random" {
  length = 5
  special = false
  override_special = "/@£$"
  lower = true
}

resource "azurerm_public_ip" "example" {
  name                    = "pip-${var.server_name}"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_windows_virtual_machine" "main" {
  name                  = "${var.server_name}-${random_string.random.result}"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  admin_username        = "${var.username}"
  admin_password        = "${var.password}"
  size                  = "${var.vm_size}"

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-21h2-pro-g2"
    version   = "latest"
  }
  os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

 connection {
        host = self.main.public_ip_address
        user = "${var.username}"
        type = "winrm"
        password = "${var.password}"
        insecure = true
        timeout  = "15m"
        port = 5985
        https = false    
    }

  tags = {
    environment = "dev"
  }
}


resource "azurerm_virtual_machine_extension" "custom_register_agent" {
  name                 = "custom_register_agent"
  virtual_machine_id   = azurerm_windows_virtual_machine.main.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<SETTINGS
  {
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.DevopsAgentSetup.rendered)}')) | Out-File -filepath AgentSetUp.ps1\" && powershell -ExecutionPolicy Unrestricted -File AgentSetUp.ps1 -AZP_URL ${data.template_file.DevopsAgentSetup.vars.azp_url} -AZP_TOKEN ${data.template_file.DevopsAgentSetup.vars.azp_token} -AZP_AGENT_NAME ${data.template_file.DevopsAgentSetup.vars.azp_agent_name}  -AZP_POOL ${data.template_file.DevopsAgentSetup.vars.azp_pool}" 

  }
  SETTINGS
}

data "template_file" "DevopsAgentSetup" {

    template = "${file("./Powershell/AgentSetUp.ps1")}"
    vars = {
        azp_url             = "${var.azp_url}"
        azp_token           = "${var.azp_token}"
        azp_agent_name      = "${var.server_name}-${random_string.random.result}"
        azp_pool            = "${var.azp_pool}"
  }
}



output "public_ip_address" {
  value = azurerm_windows_virtual_machine.main.id
}

