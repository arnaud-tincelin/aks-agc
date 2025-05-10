data "azurerm_kubernetes_cluster" "this" {
  name                = var.kubernetes_cluster.name
  resource_group_name = var.kubernetes_cluster.resource_group_name
}

data "azurerm_subnet" "gateway" {
  name                 = var.gateway_subnet.name
  virtual_network_name = var.gateway_subnet.vnet_name
  resource_group_name  = var.gateway_subnet.resource_group_name
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = "alb-test-infra"
  }
}

locals {
  alb_name     = "alb"
  gateway_name = "gateway-alb"
}

resource "kubernetes_manifest" "alb" {
  manifest = yamldecode(templatefile("${path.module}/manifests/alb.yaml.tpl", {
    name      = local.alb_name
    namespace = kubernetes_namespace.this.metadata.0.name
    subnet_id = data.azurerm_subnet.gateway.id
    }
  ))
}

resource "kubernetes_manifest" "gateway" {
  manifest = yamldecode(templatefile("${path.module}/manifests/gateway.yaml.tpl", {
    name          = local.gateway_name
    namespace     = kubernetes_namespace.this.metadata.0.name
    alb_name      = local.alb_name
    alb_namespace = kubernetes_namespace.this.metadata.0.name
    }
  ))
  depends_on = [kubernetes_manifest.alb]
}

resource "kubernetes_manifest" "route" {
  manifest = yamldecode(templatefile("${path.module}/manifests/route.yaml.tpl", {
    namespace         = kubernetes_namespace.this.metadata.0.name
    gateway_name      = local.gateway_name
    gateway_namespace = kubernetes_namespace.this.metadata.0.name
    }
  ))
  depends_on = [kubernetes_manifest.gateway]
}

resource "kubernetes_manifest" "service" {
  manifest = yamldecode(templatefile("${path.module}/manifests/service.yaml.tpl", {
    namespace = kubernetes_namespace.this.metadata.0.name
    }
  ))
}

resource "kubernetes_manifest" "deployment" {
  manifest = yamldecode(templatefile("${path.module}/manifests/deployment.yaml.tpl", {
    namespace = kubernetes_namespace.this.metadata.0.name
    }
  ))
}
