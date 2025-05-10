# Documentation: https://learn.microsoft.com/en-gb/azure/application-gateway/for-containers/quickstart-deploy-application-gateway-for-containers-alb-controller?tabs=install-helm-linux#install-the-alb-controller

locals {
  alb_controller_namespace = "azure-alb-system"
}

resource "azurerm_user_assigned_identity" "alb_controller" {
  name                = "alb-controller"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_role_assignment" "alb_controller_can_read_managed_rg" {
  scope                = azurerm_kubernetes_cluster.this.node_resource_group_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.alb_controller.principal_id
}

resource "azurerm_role_assignment" "alb_controller_can_configure_gateway" {
  scope                = azurerm_kubernetes_cluster.this.node_resource_group_id
  role_definition_name = "AppGw for Containers Configuration Manager"
  principal_id         = azurerm_user_assigned_identity.alb_controller.principal_id
}

resource "azurerm_role_assignment" "alb_controller_is_gateway_subnet_contributor" {
  scope                = azurerm_subnet.app_gw_containers.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.alb_controller.principal_id
}

resource "azurerm_federated_identity_credential" "alb_controller_aks" {
  name                = "azure-alb-identity" // ALB Controller requires a federated credential with the name of azure-alb-identity
  parent_id           = azurerm_user_assigned_identity.alb_controller.id
  resource_group_name = azurerm_resource_group.this.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.this.oidc_issuer_url
  subject             = "system:serviceaccount:${local.alb_controller_namespace}:alb-controller-sa"
}

resource "helm_release" "alb_controller" {
  name             = "alb-controller"
  repository       = "oci://mcr.microsoft.com/application-lb/charts"
  chart            = "alb-controller"
  namespace        = "alb-controller-helm"
  create_namespace = true
  version          = "1.6.7" // https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/alb-controller-release-notes
  set = [
    {
      name  = "albController.namespace"
      value = local.alb_controller_namespace
    },
    {
      name  = "albController.podIdentity.clientID"
      value = azurerm_user_assigned_identity.alb_controller.client_id
    }
  ]
}
