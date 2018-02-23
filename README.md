# Kube hackfest project
Kube hackfest project repo

## Prepare K8S dhackfest
- Azure CLI 2.0
https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

- Docker
https://docs.docker.com/docker-for-windows/install/
https://docs.docker.com/docker-for-mac/install/
Enable Shared Drives - https://docs.docker.com/docker-for-windows/#shared-drives 

- Install kubectl
```
az aks install-cli
```

- Helm
https://github.com/kubernetes/helm/releases

- Bash On Windows
https://docs.microsoft.com/en-us/windows/wsl/install-win10

- Azure Cloud Shell
https://docs.microsoft.com/en-us/azure/cloud-shell/overview?view=azure-cli-latest

- Azure Service Principal
https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal
Enable the service principal as a ‘Contributor’ on the subscription and save your Tenant Id, Subscription Id, Client Id (User id), Client Password (Secret)

- Docker Hub
Create a user - https://hub.docker.com

- GitHub
Create a user - https://github.com

- Visual Studio Code
https://code.visualstudio.com/

- Recommended VS Code extensions
YAML
Docker
ESLint
C#
Python
Beautify
Nuget Package Manager
GitHub - Repo

- Clone the following repo to run through the workshop: 
https://github.com/torosent/containers-k8s-workshop
git clone https://github.com/torosent/containers-k8s-workshop.git

## Azure Container Registry

- Create Resource group
```
az group create --name myResourceGroup --location eastus
```

- Create a container registry
```
az acr create --resource-group myResourceGroup --name myContainerRegistry007 --sku Basic
```

- Login to ACR
```
az acr login --name <acrName>
```

- Pull test docker image
```
docker pull microsoft/aci-helloworld
```

- Get ACR Server info
```
az acr list --resource-group myResourceGroup --query "[].{acrLoginServer:loginServer}" --output table
```

- Tag docker image and push
```
docker tag microsoft/aci-helloworld <acrLoginServer>/aci-helloworld:v1
docker push <acrLoginServer>/aci-helloworld:v1
```

- List repo in Registry
```
az acr repository list --name <acrName> --output table
```

## Azure Kubernetes Service - AKS
- Check az cli version
```
az --version
```
2.0.21 or higher

- Enable AKS preview
```
az provider register -n Microsoft.ContainerService
```

- Create resource group
```
az group create --name myResourceGroup --location eastus
```

- Create AKS cluster
```
az aks create --resource-group myResourceGroup --name myAKSCluster --node-count 1 --generate-ssh-keys
```

- Install kubectl for Azure cli
```
az aks install-cli
```

- Get kubernetes cluster credential and config
```
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster
```

- List kube node
```
kubectl get nodes
```

- Create Azure Vote YAML
```
    apiVersion: apps/v1beta1
    kind: Deployment
    metadata:
      name: azure-vote-back
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            app: azure-vote-back
        spec:
          containers:
          - name: azure-vote-back
            image: redis
            ports:
            - containerPort: 6379
              name: redis
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: azure-vote-back
    spec:
      ports:
      - port: 6379
      selector:
        app: azure-vote-back
    ---
    apiVersion: apps/v1beta1
    kind: Deployment
    metadata:
      name: azure-vote-front
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            app: azure-vote-front
        spec:
          containers:
          - name: azure-vote-front
            image: microsoft/azure-vote-front:v1
            ports:
            - containerPort: 80
            env:
            - name: REDIS
              value: "azure-vote-back"
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: azure-vote-front
    spec:
      type: LoadBalancer
      ports:
      - port: 80
      selector:
        app: azure-vote-front
```

- Run application 
```
kubectl create -f azure-vote.yaml
```

- Get service status
```
kubectl get service azure-vote-front --watch
```

- Monitor
```
kubectl proxy
```

- Delete cluster
```
az group delete --name myResourceGroup --yes --no-wait
```

- Scale AKS node
```
az aks scale --resource-group=myResourceGroup --name=myAKSCluster --node-count 3
```

- Manually scale pods
```
kubectl get pods
kubectl scale --replicas=5 deployment/azure-vote-front
kubectl get pods
```

- Autoscale pods

## Helm
- Install Helm
https://github.com/kubernetes/helm/blob/master/docs/install.md

- Initialize Helm
```
helm init
```

- Find helm chart
```
helm search
```

- Helm repo update
```
helm repo update
```

- Install from Helm
```
helm install stable/nginx-ingress
```

## Jenkins Deployment
- Deploy Jenkins VM to Azure
https://azuremarketplace.microsoft.com/en-us/marketplace/apps/azure-oss.jenkins?tab=Overview   

- Proxy connection
```
ssh -L 127.0.0.1:8080:localhost:8080 userid@dwjenkins01.eastus.cloudapp.azure.com
```

- Login to Dashboard
localhost:8080
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

- Error handle
```
unix /var/run/docker.sock: connect: permission denied Build step 'Execute shell' marked build as failure Finished: FAILURE
sudo usermod -a -G root jenkins
sudo service jenkins restart
sudo chmod 664 /var/run/docker.sock
```

[How to create a development infrastructure on a Linux VM in Azure with Jenkins, GitHub, and Docker](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-jenkins-github-docker-cicd)  

[Continuous deployment with Jenkins and Azure Container Service](https://docs.microsoft.com/en-us/azure/aks/jenkins-continuous-deployment)  

https://docs.microsoft.com/en-us/azure/container-service/kubernetes/container-service-kubernetes-jenkins  

## ACS Engine
Config ACS Engine to deply GPU on cluster node  
[Microsoft Azure Container Service Engine - Kubernetes](https://github.com/CloudBreadPaPa/acs-engine/blob/master/docs/kubernetes.md)

- Install acs-engine and basic usage
https://github.com/CloudBreadPaPa/acs-engine/blob/master/docs/acsengine.md#install-acs-engine

- Deploy acs-engine Kubernetes cluster
https://github.com/CloudBreadPaPa/acs-engine/blob/master/docs/kubernetes/deploy.md
```
az login
az account list -o table
acs-engine deploy --subscription-id <SUBSCRIPTION_ID> --dns-prefix <DNS_NAME> --location eastus --auto-suffix --api-model examples/kubernetes.json
```
[acs-engine Kubernetes workthrough](https://github.com/CloudBreadPaPa/acs-engine/blob/master/docs/kubernetes/walkthrough.md)

- acs-engine Kubernetes GPU
[acs-engine GPU Kubernetes json script](https://github.com/CloudBreadPaPa/acs-engine/blob/master/examples/kubernetes-gpu/kubernetes.json)

## Monitoring - Datadog

## PostgreSQL 

- Create resource group
```
az group create --name dwrgpostgresql --location westus
```

- Deploy postgres server
```
az postgres server create --resource-group dwrgpostgresql --name dwpostgresql01  --location westus --admin-user <USERID>  --admin-password <PASSWORD> --performance-tier Basic --compute-units 50 --version 9.6
```

- Firewall setting
```
az postgres server firewall-rule create --resource-group dwrgpostgresql --server dwpostgresql01 --name AllowAllIps --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255
```

- Show server information
```
az postgres server show --resource-group dwrgpostgresql --name dwpostgresql01
```

- psql login and basic query
```
psql --host=dwpostgresql01.postgres.database.azure.com --port=5432 --username=<USERID>@dwpostgresql01 --dbname=postgres
CREATE DATABASE mypgsqldb;
\c mypgsqldb
create table t1(c1 char, c2 char);
insert into t1 values('1', '2');
select * from t1;
```
- Delete resource group
```
az group delete --name dwrgpostgresql
```

## Persistent Volumn

Azure file or Azure Disk
Reference link : https://kubernetes.io/docs/concepts/storage/persistent-volumes/  

- Create PVC
```
kubectl create -f deployment-storage.yaml
```

- Get PVC
```
kubectl get pvc
```

- Deploy MySQL w/ PVC
```
kubectl create -f deployment-mysql.yaml
```

- Deploy Wordpress w/ PVC
```
kubectl create -f deployment-wordpress.yaml
```

- Login to Wordpress and set data

- Delete Pod and Services
```
kubectl delete pod wordpress
kubectl delete pod wordpress-mysql
kubectl delete services wordpress
kubectl delete services wordpress-mysql
kubectl delete deployment wordpress
kubectl delete deployment wordpress-mysql
```

- Re-deploy and check the PV data








