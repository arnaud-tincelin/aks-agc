apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: aspnetapp
  namespace: ${namespace}
spec:
  parentRefs:
  - name: ${gateway_name}
    namespace: ${gateway_namespace}
  rules:
  - backendRefs:
    - name: aspnetapp-service
      port: 80
