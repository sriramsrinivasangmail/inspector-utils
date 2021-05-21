# inspector-utils

Helper image to test out network connectivity in Kubernetes - with nc

The image at this time is `quay.io/sriramsrinivasan/inspector-utils:v1`  and can be pulled without needing a pull secret. However, if you need to amend and rebuild the image - use [./build.sh](./build.sh)

## Testing the image with docker first

[./test-nc-server.sh](./test-nc-server.sh)  - to start the "server" listening on port 33001

[./test-nc-client.sh](./test-nc-client.sh)  - is a nc client that connects to that test server 

---

## Testing in kubernetes

In this example, we will stand up a Stateful set and have its members expose a tcp port (33001) as the "servers".  We will then start up a "inspector" pod that we can then use to test out connectivity.

Login to your Kube and pick a namespace.

`cd ./k8s`

### Deploy the Statefulset

```
   kubectl apply -f ./sts-tester-no-vol.yaml
```

- ensure all members are up and  have IPs assigned

`   kubectl get pods -l app=sts-app -o wide`

```
NAME               READY   STATUS    RESTARTS   AGE   IP              NODE                                NOMINATED NODE   READINESS GATES
sts-tester-tcp-0   1/1     Running   0          83m   10.254.2.14     worker3.zen-ocp43.os.fyre.ibm.com   <none>           <none>
sts-tester-tcp-1   1/1     Running   0          83m   10.254.24.54    worker1.zen-ocp43.os.fyre.ibm.com   <none>           <none>
sts-tester-tcp-2   1/1     Running   0          82m   10.254.18.212   worker0.zen-ocp43.os.fyre.ibm.com   <none>           <none>
```

- confirm that the headless svc is created

`kubectl get svc sts-svc`

```
NAME      TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)     AGE
sts-svc   ClusterIP   None         <none>        33001/TCP   78m
```

this svc is "headless" - so it has no cluster IP


- the member end-points should also be correctly associated with the svc

`kubectl describe svc sts-svc`

```
Name:              sts-svc
Namespace:         ez-cr-add-on-operator-system
Labels:            app=sts-svc-app
Annotations:       <none>
Selector:          app=sts-app
Type:              ClusterIP
IP:                None
Port:              sts-tester-tcp  33001/TCP
TargetPort:        33001/TCP
Endpoints:         10.254.18.212:33001,10.254.2.14:33001,10.254.24.54:33001
Session Affinity:  None
Events:            <none>
```


### Deploy inspector-utils 

```kubectl apply -f ./inspector-utils.sh```

The container has a `sleep` - so it will stay up for us to run our tests by exec-ing in.

- confirm that its Running
  
```kubectl get pods -l app=inspector-app -o wide```

```
NAME                               READY   STATUS    RESTARTS   AGE   IP            NODE                                NOMINATED NODE   READINESS GATES
inspector-utils-5ccd6bd5cc-h8vj2   1/1     Running   1          75m   10.254.2.32   worker3.zen-ocp43.os.fyre.ibm.com   <none>           <none>
```

---

### Testing connectivity with nc


#### Success message

A successful connection would respond with 

 `Connection to sts-svc 33001 port [tcp/*] succeeded!`

#### Failure messages

 A failure may come in many forms - 

   -  Connection refused

```
nc: connect to sts-tester-tcp-2.sts-svc port 33003 (tcp) failed: Connection refused
command terminated with exit code 1
```
 
   -  DNS resolution issue:

```
nc: getaddrinfo: Name does not resolve
command terminated with exit code 1
```

---

1). Check if the headless service resolves fine

```kubectl exec -it $(oc get pods -l app=inspector-app -o jsonpath='{.items[0].metadata.name}') -- nc -vz sts-svc 33001```


2). Check if you can reach each member directly from the inspector pod

**Note** - each individual statefulset member is indentified by `<statefulset-name>-<ordinal>.<headless-svc-name>`

```kubectl exec -it $(oc get pods -l app=inspector-app -o jsonpath='{.items[0].metadata.name}') -- nc -vz sts-tester-tcp-0.sts-svc 33001```

```kubectl exec -it $(oc get pods -l app=inspector-app -o jsonpath='{.items[0].metadata.name}') -- nc -vz sts-tester-tcp-1.sts-svc 33001```

```kubectl exec -it $(oc get pods -l app=inspector-app -o jsonpath='{.items[0].metadata.name}') -- nc -vz sts-tester-tcp-2.sts-svc 33001```


3). Test if one member can reach another

In the examples below, we exec into the first member (the pod should be `sts-tester-tcp-0`) and use nc to reach itself and others.

```kubectl exec -it $(oc get pods -l app=sts-app -o jsonpath='{.items[0].metadata.name}') -- nc -vz sts-tester-tcp-0.sts-svc 33001```

```kubectl exec -it $(oc get pods -l app=sts-app -o jsonpath='{.items[0].metadata.name}') -- nc -vz sts-tester-tcp-1.sts-svc 33001```

```kubectl exec -it $(oc get pods -l app=sts-app -o jsonpath='{.items[0].metadata.name}') -- nc -vz sts-tester-tcp-2.sts-svc 33001```
