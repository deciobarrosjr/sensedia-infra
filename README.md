
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

The following variable should be changed to choose the desired infra structure requirements for the challenge:<br><br>
> To choose between the private/public subnets, change the following variable:<br>
 <span style="color: green;">AWS-Resources -> L1-eks -> terraform.tfvars -> pub-priv-sel</span>
<br><br>


<span style="color: red;">NOTE</span>: the provisioning for this challenge will be done manually. There are many other better alternatives like creating a pipeline to deliver the infrastructure or registering this repository with an ArgoCD previously installed on another cluster for example.
I don´t believe that i will have time to do any so i will try to create the pipeline for the aplication CI/CD.

## Cluster and Node Group delivered on Private Subnets and internet-facing Load Balancer
The following image illustrates the choosed architecture for the challenge implementation.<br>
The wrok-nodes will be delived on a Private Netwrod.<br>
In general, this is a good alternative for client facing applications.<br>

![image](/images/private-subnets-internet-facing-lb.jpg)

On the arquitecture illustrated above, three applications will be delivered named: <span style="color: chocolate;">my-apl-1, my-apl-2, my-apl-3</span>.<br>

Each of these application will be delivered with different Service Type based on the values.yaml defined for each application.<br>

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
