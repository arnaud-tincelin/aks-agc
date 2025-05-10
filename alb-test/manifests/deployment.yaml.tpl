apiVersion: apps/v1
kind: Deployment
metadata:
  name: aspnetapp-deployment
  namespace: ${namespace}
spec:
  replicas: 3
  selector:
    matchLabels:
      app: aspnetapp
  template:
    metadata:
      labels:
        app: aspnetapp
    spec:
      containers:
      - name: aspnetapp
        image: mcr.microsoft.com/dotnet/samples:aspnetapp
        ports:
        - containerPort: 8080
        resources:
          limits:
            cpu: 200m
            memory: 200M
          requests:
            cpu: 100m
            memory: 100M
