apiVersion: apps/v1
kind: Deployment
metadata:
  name: inspector-utils
spec:
  selector:
    matchLabels:
      app: inspector-app # has to match .spec.template.metadata.labels
  replicas: 1 
  template:
    metadata:
      labels:
        app: inspector-app # has to match .spec.selector.matchLabels
    spec:
      containers:
      - name: inspect-tcp-con
        image: "quay.io/sriramsrinivasan/inspector-utils:v1"
        imagePullPolicy: "IfNotPresent"
        command: ['sleep', '3600']
