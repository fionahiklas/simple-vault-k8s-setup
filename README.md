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

```
minikube start --driver=docker
```

Enable ingress

```
minikube addons enable ingress
```

