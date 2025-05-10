# Demo Repository for AKS Overlay with Application Gateway for Containers

See [AKS CNI Overlay with App Gateway for Containers](https://medium.com/@arnaud.tincelin/aks-cni-overlay-with-app-gateway-for-containers-b2b62ab267fd) for a detailed walkthrough.

More information on Azure Documentation:
- [Container networking with Application Gateway for Containers](https://learn.microsoft.com/en-gb/azure/application-gateway/for-containers/container-networking)
- [Quickstart: Deploy Application Gateway for Containers ALB Controller](https://learn.microsoft.com/en-gb/azure/application-gateway/for-containers/quickstart-deploy-application-gateway-for-containers-alb-controller?tabs=install-helm-windows)

## Deployment

Pre-requisites

- An Azure Subscription
- [Terraform](https://developer.hashicorp.com/terraform)

Deployment

1. Deploy the infrastructure with the [./iac-setup](./iac-setup) module:

```bash
# Change the target subscription ID of the azurerm provider
terraform init
terraform apply --auto-approve
```

This module deploys all required components to be able to expose workloads through the Gateway.

2. Deploy the sample application with the [./-alb-test](./-alb-test) module:

```bash
# Change the target subscription ID of the azurerm provider
terraform init
# If you changed some value in the iac-setup module, you have to update the variables.auto.tfvars file
terraform apply --auto-approve
```

Once this is done, the application shall be accessible from your browser (http only).
