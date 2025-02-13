
# Sensedia Infra Structure for HelloWorld
<br>
The following container will work as a technical challenge using the AWS Elastic Load Balancer (ELB) on the options <span style="color: Chocolate;">ClusterIP</span>, <span style="color: Chocolate;">NodePort</span> and <span style="color: Chocolate;">LoadbBalancer</span>.<br>
The objective is creating an infra structure to be used by the Sensedia Apl to delivery a simple Hello World.<br>
<br>
This Repository has the following folder structure:
<br><br>


* <span style="color: Chocolate;">AWS-Resources</span> - This folder contains all the AWS resources to be provisioned by layers as the best practices suggests: <br>
	* L0-vpc: will create all nework resources
	* L1-eks: will create de Cluster and the Node Group
	* L2-irsa: will provision the IAM for Service Account.
<br><br>

# Provisionnig the infrastruture

This Repository may be used on 4 different cluster arquitectures combining the use of Public/Private subnets for the worker nodes and internal/internet-facing for the Load Balancer Schema on the application side.<br>

The following variables should be changed to choose the desired infra structure requirements for the challenge:<br><br>
> To choose between the private/public subnets, change the following variable:<br>
 <span style="color: green;">AWS-Resources -> L1-eks -> terraform.tfvars -> pub-priv-sel</span>
<br><br>
> To choose betweeen internal/internet-facing Load Balancer, change the following variables (AlbScheme-1, AlbScheme-2, AlbScheme-3) on the following file:
<br>
<span style="color: green;">AWS-Resources -> L3-deploy-apl -> terraform.tfvars -> pub-priv-sel</span>

<span style="color: red;">NOTE</span>: the provisioning for this challenge will be done manually. There are many other better alternatives like creating a pipeline to deliver the infrastructure or registering this repository with an ArgoCD previously installed on another cluster for example.
I don´t believe that i will have time to do any so i will try to create the pipeline for the aplication CI/CD.


## 1. Cluster and Node Group delivered on Public Subnets and internet-facing Load Balancer
The following image illustrates how this challeng works, in general, and what is required to test the application:

![image](/images/public-subnets-internet-facing-lb.jpg)

This is probably the most appropriate arquitecture for services to be accessed by customers like applications front-end.
The three applications <span style="color: chocolate;">my-apl-1, my-apl-2, my-apl-3</span> will be delivered on Public Subnets.<br>
Three PODs will be created with each of then having the service.type as: <span style="color: chocolate;">ClusterIP, LoadBalancer and NodePort</span>.<br>
If you log inside any PODs (or create a new one on the cluster), you will be able to access any of the application using the following curl:<br>

<span style="color: green;">curl -o /dev/null -s -w '%{http_code}' http://</span><span style="color: pink;"><POD_IP></span><span style="color: green;">:8080</span>

This arquitecture will create 3 <span style="color: chocolate;">external Load Balancers</span> and the DNS Name of each of then is used to access the application like illustrated bellow:
<br><br>
<span style="color: green;">http://</span><span style="color: pink;"><LOAD_BALANCER_DNS></span>
<br>
<span style="color: green;">http://</span><span style="color: pink;"><LOAD_BALANCER_DNS></span><span style="color: green;">/health</span>
<br><br>
<span style="color: green;">curl -o /dev/null -s -w '%{http_code}' http://</span><span style="color: pink;"><LOAD_BALANCER_DNS></span><span style="color: green;"></span>
<br>
<span style="color: green;">curl -o /dev/null -s -w '%{http_code}' http://</span><span style="color: pink;"><LOAD_BALANCER_DNS></span><span style="color: green;"></span><span style="color: green;">/health</span>
<br>
> Healh Check: allthough the application access is working correctly, i´m facing problems with the health check as illustrated by the image bellow. Still needs investigation. Note that the health URL endpoint is being accessed correctly from outside.


## 2. Cluster and Node Group delivered on Private Subnets and internal Load Balancer
The following image illustrates how this POC works, in general, and what is required to test the application:

![image](/images/private-cluster.jpg)

On this arquitecture, the three applications my-apl-1, my-apl-2, my-apl-3 will be delivered on Private Subnets.<br>
Three PODs will be created with each of then having the service.type as: ClusterIP, LoadBalancer and NodePort.<br>
If you log inside any PODs (or create a new one on the cluster), you will be able to access any of the application using the following curl:<br>

<span style="color: green;">curl -o /dev/null -s -w '%{http_code}' http://</span><span style="color: pink;"><POD_IP></span><span style="color: green;">:8080</span>

To access the application outside the Cluster you will need a Load Balancer.<br>
This is basically an internal load balancer.<br>
The only application that can be acessible from outside the Cluster (but inside the VPC) is my-apl-2 that is delivered using the Service Type LoadBalancer. So in this case the ELB Controller will automatically create a load balancer to my-apl-2.<br>
<br>
To thest the application from outside the cluster i had to create an EC2 instance on a public subnet on the same VPC.<br>
The EC2 should be in a public subnet just to be acessible from outside AWS.<br>
The EC2 should belong to a Security Group that allows SSH and http. SSH is necessary to be able to access the instance using the AWS console. The http is necessary to access the application using curl as detailed bellow:<br>

<span style="color: green;">curl -o /dev/null -s -w '%{http_code}' http://</span><span style="color: pink;"><LOAD_BALANCER_DNS></span><span style="color: green;">:80</span>
<br>
<span style="color: red;">NOTE</span>: note that we are using the port 80 that is the port exposed (outside the cluster) by the service of this application.
<br>
> The Helth Check access the Targets correctly.


## 3. Cluster and Node Group delivered on Private Subnets and internet-facing Load Balancer
The following image illustrates how this POC works, in general, and what is required to test the application:

![image](/images/private-subnets-internet-facing-lb.jpg)

On this arquitecture, the three applications <span style="color: chocolate;">my-apl-1, my-apl-2, my-apl-3</span> will be delivered on Private Subnets.<br>
Three PODs will be created with each of then having the service.type as: ClusterIP, LoadBalancer and NodePort.<br>
If you log inside any PODs (or create a new one on the cluster), you will be able to access any of the application using the following curl:<br>

<span style="color: green;">curl -o /dev/null -s -w '%{http_code}' http://</span><span style="color: pink;"><POD_IP></span><span style="color: green;">:8080</span>
<br>

The figure above illustrate that we are using the <span style="color: chocolate;">internet-facing</span> as the Service Scheme for all three application. In this case three Load Balancers will be created for each application as illustrated by the image bellow:<br>

![image](/images/lb-private-subnets-internet-facing.jpg)

To access each application (<span style="color: chocolate;">my-apl-1, my-apl-2, my-apl-3</span>), just copy the DNS name of each application and access it from a Web Browser.
<br>
> Healh Check: allthough the application access is working correctly, i´m facing problems with the health check as illustrated by the image bellow. <span style="color: red;">Still needs investigation</span>. Note that the health URL endpoint is being accessed correctly from outside.

![image](/images/health-private-subnets-internet-facing.jpg)



## Requirements

1. The following devcontainer.env will be used by this container POC:

```yaml
	"name": "Ubuntu",
	"image": "mcr.microsoft.com/devcontainers/base:jammy",
	"features": {
		"ghcr.io/devcontainers/features/aws-cli:1": {},
		"ghcr.io/devcontainers-contrib/features/kubectl-asdf:2": {},
		"ghcr.io/devcontainers/features/terraform:1": {},
		"ghcr.io/devcontainers/features/docker-in-docker:2": {}
		
	},

	"customizations": {
		"vscode": {		
			"extensions": [
                "GitHub.copilot",
				"hashicorp.terraform",
				"EthanSK.restore-terminals",
                "ritwickdey.LiveServer",
				"ms-azuretools.vscode-docker",
				"ms-kubernetes-tools.vscode-kubernetes-tools",
				"ms-python.python"
			]
		}
	},
```
2. The <span style="color: Chocolate;">postCreateCommand</span> will be responsible for executing the followinf bash script used by this container POC, installing the following:

* python3, PIP3 and the flask module used on the python application
* helm
<br>

``` bash
sudo apt-get update && 
sudo apt-get upgrade -y && 
sudo apt-get install python3-pip -y && 
pip3 install flask && 
wget https://get.helm.sh/helm-v3.14.0-linux-amd64.tar.gz && 
tar xvf helm-v3.14.0-linux-amd64.tar.gz && 
sudo mv linux-amd64/helm /usr/local/bin && 
rm helm-v3.14.0-linux-amd64.tar.gz && 
rm -rf linux-amd64",
```
<br>
