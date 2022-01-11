provider "azurerm" {
  features {
    
  }
}
locals {
   example = resource.azurerm_resource_group.example
    vnet-name = resource.azurerm_virtual_network.example.name
    subnet-id = resource.azurerm_subnet.subnet-1.id
    tags = var.additional_tags == null ? resource.azurerm_resource_group.example.tags : merge(var.additional_tags, resource.azurerm_resource_group.example.tags)
}
resource "azurerm_resource_group" "example"{
    name = "new-example"
    location = "eastus"
    
}

# resource "azurerm_virtual_network" "example"{
#     name              = "new-vnet"
#     address_space     = ["10.0.0.0/16"]
#     resource_group_name = local.example.name
#     location = "eastus"

# }

# resource "azurerm_subnet" "subnet-1" {
#     name = "internal"
#     resource_group_name  = local.example.name            #data.azurerm_resource_group.example.name
#     virtual_network_name = local.vnet-name   
#     address_prefixes     = ["10.0.2.0/24"]
# }

# resource "azurerm_network_interface" "example"{

#     name ="new_nic"
#     location = resource.azurerm_resource_group.example.location
#     resource_group_name = local.example.name
#     ip_configuration{

#         name = "internal"
#         subnet_id = resource.azurerm_subnet.subnet-1.id
#         private_ip_address_allocation = "Dynamic"
#     }

# }


# resource "azurerm_linux_virtual_machine" "example"{

#     name = "new-vm"
#     location ="eastus"
#     resource_group_name =local.example.name
#     size ="Standard_F2"
#     admin_username ="adminuser"
#     admin_password ="Password@1234"
#     disable_password_authentication = false
#     network_interface_ids =[
#         azurerm_network_interface.example.id
#     ]
    

#     os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }

# }

resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw

  sensitive = true
}