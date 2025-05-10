variable "kubernetes_cluster" {
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "alb_controller_namespace" {
  type = string
}

variable "gateway_subnet" {
  type = object({
    name                = string
    vnet_name           = string
    resource_group_name = string
  })
}
