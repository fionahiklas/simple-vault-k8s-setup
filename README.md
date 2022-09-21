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

### Vault init

Running the following command 

```
VAULT_ADDR=http://localhost:8200 vault operator init
```

This gives the following output

```
Unseal Key 1: eVHcJSIjFE+fpv2BpmS8RlTSe4MOaSpd5TiziHaTGO2P
Unseal Key 2: TnCyegblAjAvd7YGyRHpD/eLZTWJyDtacjNG9YADdIiQ
Unseal Key 3: +cjlTSKzxQ02c2199xaRwvGhoV9a8GfBXxhYn5xijMsV
Unseal Key 4: hXAQNHDzPk0AmqiwsjCXcMySuhYrEIrXBiuZbKEvObgU
Unseal Key 5: NDDsTf4U/UYaw2PlDHFyDspgyxFUqf1jOD3MCdfWlRst

Initial Root Token: hvs.l9wFxa9sOid2Hi06u0b2Dmxx

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated root key. Without at least 3 keys to
reconstruct the root key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```

* Need to run the following command 3 times each with difference keys

```
VAULT_ADDR=http://localhost:8200 vault operator unseal
```

* Each time this runs there is a prompt to type in the keys
* The output will look like this

```
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       51668a51-ff35-f6db-ec9d-569dc2bb6123
Version            1.11.3
Build Date         2022-08-26T10:27:10Z
Storage Type       file
HA Enabled         false
```

* After three keys the output changes to this

```
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.11.3
Build Date      2022-08-26T10:27:10Z
Storage Type    file
Cluster Name    vault-cluster-a935845e
Cluster ID      caaf2e65-7242-0b52-48a0-4ea8c77f5d2a
HA Enabled      false
```

### Setup 

* Following the [tutorial instructions](https://learn.hashicorp.com/tutorials/vault/getting-started-deploy)
* Login into the newly setup vault

```
VAULT_ADDR=http://localhost:8200 vault login
```

* This asks for the "Initial Root Token" that was output from init
* The output from the command will be like this

```
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                hvs.l9wFxa9sOid2Hi06u0b2Dmxx
token_accessor       X9QIdvjwX6x7DkNV1cNnuPNx
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```

* Also the file `$HOME/.vault-token` will be created with the token value
* 
