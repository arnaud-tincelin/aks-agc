apiVersion: v1
kind: Service
metadata:
  name: aspnetapp-service
  namespace: ${namespace}
spec:
  selector:
    app: aspnetapp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
