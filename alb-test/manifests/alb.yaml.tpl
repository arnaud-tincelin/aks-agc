apiVersion: alb.networking.azure.io/v1
kind: ApplicationLoadBalancer
metadata:
  name: ${name}
  namespace: ${namespace}
spec:
  associations:
    - ${subnet_id} # Azure ARM resource ID
