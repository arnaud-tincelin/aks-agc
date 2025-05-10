kubernetes_cluster = {
  name                = "cni-overlay-appgwc"
  resource_group_name = "cni-overlay-appgwc"
}

alb_controller_namespace = "azure-alb-system"

gateway_subnet = {
  name                = "appgw-containers"
  vnet_name           = "aks-agc"
  resource_group_name = "cni-overlay-appgwc"
}
