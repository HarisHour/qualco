- Below steps were performed in Ubuntu 24.04.1 lts
- Azure CLI, Terraform should be installed

Steps:

az login

A)
--kafka--
ssh-keygen -t rsa -b 4096 -f ~/.ssh/hdinsight_kafka_key
*add it in kafka/variables.tf ("ssh_public_key" var (default = ) -> hdinsight_kafka_key.pub value)
*put Az subscription id (find it in Portal) in kafka/providers.tf 

terraform init
terraform plan
terraform apply

in kafka dir

Note: It was not possible to actually create the kafka cluster on Azure with the resources that a free subscription offers, 
however it connected and created some, before this:

"azurerm_hdinsight_kafka_cluster.kafka_cluster: Creating...
╷
│ Error: creating Kafka HDInsight Cluster (Subscription: ""
│ Resource Group Name: "hdinsight-kafka-rg"
│ Cluster Name: "kafka-hh"): performing Create: unexpected status 400 (400 Bad Request) with response: 
{"code":"BadRequest","message":"User SubscriptionId '' does not have cores left to create resource 'kafka-hh'. Required: 17, Available: 0."}"

With a regular paid subscription, i could test and troubleshoot further

B)
--aks & db--
*put Az subscription id (find it in Portal) in aks-db/providers.tf 
*set user/pass for SQL Server in aks-db/variables.tf

terraform init
terraform plan
terraform apply

in aks-db dir

Note: It was not possible to actually create the aks cluster & db on Azure due to: 

 Error: creating Kubernetes Cluster (Subscription: ""
│ Resource Group Name: "aks-rg"
│ Kubernetes Cluster Name: "spring-boot-aks-cluster"): performing CreateOrUpdate: unexpected status 400 (400 Bad Request) with response: {
│   "code": "AKSCapacityError",
│   "details": null,
│   "message": "Creating a free tier cluster is unavailable at this time in region westeurope. 
    To create a new cluster, we recommend using an alternate region, or create a paid tier cluster.
│   "subcode": ""
│  }

then tried with East US region:

 Error: creating Server (Subscription: ""
│ Resource Group Name: "aks-rg"
│ Server Name: "sqlserver-demo"): polling after CreateOrUpdate: polling failed: the Azure API returned the following error:
│
│ Status: "ProvisioningDisabled"
│ Code: ""
│ Message: "Subscriptions are restricted from provisioning in this region. 
Please choose a different region. For exceptions to this rule please open a support request with 
Issue type of 'Service and subscription limits'. See https://docs.microsoft.com/en-us/azure/sql-database/quota-increase-request for more details.

and

Error: creating Kubernetes Cluster (Subscription: ""
│ Resource Group Name: "aks-rg"
│ Kubernetes Cluster Name: "spring-boot-aks-cluster"): performing CreateOrUpdate: unexpected status 400 (400 Bad Request)
 with error: FailedIdentityOperation: Identity operation for resource 
'/subscriptions//resourceGroups/aks-rg/providers/Microsoft.ContainerService/managedClusters
/spring-boot-aks-cluster' failed with error 'Failed to perform resource identity operation. Status: 'BadRequest'. Response: '{"error":{"code":"BadRequest","message":""}}'.'.

The above errors are due to region, Azure subscription type etc, it is possible that when testing on your own environment, you won't have the same issues.
*Subscription id was removed from the pasted errors in this readme file
At this time, with very limited time to research various region functionality or actual budget to use a paid subscription, i can only provide a theoretical outline
of how this exercise would continue:

C)
--apps--
note: app1 & app2 are the same sample springboot app, just exists 2 times for the sake of the exercise
0) cd apps/app1
1) Build app1 with Maven (e.g  mvn -DskipTests package) (sample app is built though and jar already exists)
2) Build image using Dockerfile (e.g docker build -t app1-image .)
3) Same for app2 so you now have images app1-image & app2-image
4) Create Azure Container registry and login

az acr create --resource-group acr_rg --name test-reg --sku Basic
az acr login --name test-reg

5) Tag images and push them to acr

docker tag app1-image test-reg.azurecr.io/app1-image:v1
docker tag app2-image test-reg.azurecr.io/app2-image:v1
docker push test-reg.azurecr.io/app1-image:v1
docker push test-reg.azurecr.io/app2-image:v1

6) az aks get-credentials --resource-group aks_rg --name spring-boot-aks-cluster

7) create deployments and services (sample) (could also be done with terraform again, but this way is cleaner in my opinion)
cd apps
kubectl apply -f deployment-app1.yaml.yaml
kubectl apply -f deployment-app2.yaml.yaml
kubectl apply -f service-app1.yaml
kubectl apply -f service-app2.yaml
