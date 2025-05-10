# https://learn.microsoft.com/en-gb/azure/application-gateway/for-containers/how-to-traffic-splitting-gateway-api?tabs=alb-managed#deploy-the-required-gateway-api-resources
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: ${name}
  namespace: ${namespace}
  annotations:
    alb.networking.azure.io/alb-namespace: ${alb_namespace}
    alb.networking.azure.io/alb-name: ${alb_name}
spec:
  gatewayClassName: azure-alb-external
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    allowedRoutes:
      namespaces:
        from: Same
