# Azure-SelfHostedAgent-Terraform
This is an example of using Terraform for provisioning a Windows machine and registering to your Azure DevOps Organization.

# How to use
To provision using this sample, follow these steps:

* Start by cloning this repository
* Create or copy your agent pool name from Azure Devops Organization
* Configure the variables on the Variables.tf file with your information
* Authenticate to azure using the command 
  ``  
az login
`` 
* Run terraform apply
