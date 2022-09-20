# Simple k8s Vault Setup with Minikube

## Oveview

Based on the [simple-minikube-deployment](https://github.com/fionahiklas/simple-minikube-deployment)

Tested initially on an M1 Mac Studio running Docker Desktop

## Prerequisites

* Homebrew
* Docker Desktop
* minikube
* kubectl, kubectx, etc
* helm

Most of the above can be installed with [homebrew](https://brew.sh)

## Steps

### Minikube Startup

* Start minikube

```
minikube start --driver=docker
```

* Enable ingress

```
minikube addons enable ingress
```


### Vault Installation

* Following the [hashicorp tutorial](https://learn.hashicorp.com/tutorials/vault/kubernetes-raft-deployment-guide?in=vault/kubernetes)
* Creating namespace

```
kubectx     # Just check that the minikube context is selected
kubectl create namespace vault
```

* Add the Hashicorp Helm repo

```
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo list  # Check that it's been added
helm search repo hashicorp/vault # Look for vault chart
```

* The second command above should give this output 

```
NAME     	URL                                
hashicorp	https://helm.releases.hashicorp.com
```

* The third command, this output 

```
NAME           	CHART VERSION	APP VERSION	DESCRIPTION                   
hashicorp/vault	0.22.0       	1.11.3     	Official HashiCorp Vault Chart
```

* Installing this version using `helm`

```
helm install vault hashicorp/vault --namespace vault --version 0.22.0
```

* Checking that it's running 

```
kubectl --namespace='vault' get all
NAME                                        READY   STATUS    RESTARTS   AGE
pod/vault-0                                 0/1     Running   0          76s
pod/vault-agent-injector-758ffc85d7-6hfpc   1/1     Running   0          77s

NAME                               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
service/vault                      ClusterIP   10.99.61.29      <none>        8200/TCP,8201/TCP   77s
service/vault-agent-injector-svc   ClusterIP   10.110.213.168   <none>        443/TCP             77s
service/vault-internal             ClusterIP   None             <none>        8200/TCP,8201/TCP   77s

NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/vault-agent-injector   1/1     1            1           77s

NAME                                              DESIRED   CURRENT   READY   AGE
replicaset.apps/vault-agent-injector-758ffc85d7   1         1         1       77s

NAME                     READY   AGE
statefulset.apps/vault   0/1     77s
```

