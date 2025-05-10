resource "azurerm_virtual_network" "this" {
  name                = "aks-agc"
  address_space       = ["172.16.0.0/12"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "aks_nodes" {
  name                 = "aks-nodes"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["172.16.1.0/24"]
}

resource "azurerm_subnet" "app_gw_containers" {
  name                 = "appgw-containers"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["172.16.2.0/24"] // Note: The Application Gateway for Containers subnet must be a /24 prefix

  delegation {
    name = "appgw-containers-delegation"
    service_delegation {
      name    = "Microsoft.ServiceNetworking/trafficControllers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
