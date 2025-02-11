
# ELB for EKS - Introduction
<br>
The following container will work as a POC using the AWS Elastic Load Balancer (ELB) using <span style="color: Chocolate;">ClusterIP</span>, <span style="color: Chocolate;">NodePort</span> and <span style="color: Chocolate;">LoadbBalancer</span>.<br>
The objective is using a very simple Helo World application that will be packaged using Helm Chart and deployed using Terraform.<br>
<br>
This POC has the following folder structure:
<br><br>

* <span style="color: Chocolate;">APL-HelloWorld</span> - contains the Hello World python application.
* <span style="color: Chocolate;">HLM-HelloWorld</span> - This folder contains the helm chart that will be use to package the applicatiion.
* <span style="color: Chocolate;">AWS-Resources</span> - This folder contains all the AWS resources to be provisioned by layers: <br>
	* L0-vpc: will create all nework resources
	* L1-eks: will create de Cluster and the Node Group
	* L2-irsa: will provision the IAM for Service Account.
	* L3-deploy-apl: will deploy 3 PODs using the same Helm Chart packaged before and with different running parameters.
* <span style="color: Chocolate;">Scripts</span>
	* force-apply-all: this script is responsible for creating and deploying to ECR the docker and Helm Package images. After this it will execute the terraform config files to deploy the application. This script executes the following actions:
	<br>

		> CREATES THE DOCKER IMAGE LOCALLY<br>
		> CREATE AN ECR ON AWS TO HOLDS THE APPLICATION DOCKER IMAGE<br>
		> AUTHENTICATE DOCKER TO ECR<br>
		> PUSHING THE DOCKER IMAGE TO ECR<br>
		> EXECUTES THE HELM CHART LINT<br>
		> PACKAGE THE HELM CHART<br>
		> CREATE AN ECR ON AWS TO HOLDS THE HELM CHART CREATED<br>
		> AUTHENTICATE HELM TO ECR<br>
		> PUSH THE HELM CHART TO THE ECR CREATED<br>
		> DEPLOY THE AWS RESOURCES<br>

		This script could works as a base for creating a pipeline on a similar project.

	* force-destroy-all: responsible for destroying everything that was created by the force-apply-all script.

<br><br>

# Running this POC

This POC may be executed on 4 different cluster arquitectures combining the use of Public/Private subnets for the worker nodes and internal/internet-facing for the Load Balancer Schema.<br>

The following variables may be changed to achieve the desired POC between the four combinations:<br><br>
To choose between the private/public subnets, change the folling variable:<br>
 <span style="color: green;">AWS-Resources -> L1-eks -> terraform.tfvars -> pub-priv-sel</span>
<br>
To choose betweeen internal/internet-facing Load Balancer, change the following variables (AlbScheme-1, AlbScheme-2, AlbScheme-3) on the following file:
<br>
<span style="color: green;">AWS-Resources -> L3-deploy-apl -> terraform.tfvars -> pub-priv-sel</span>


## 1. Cluster and Node Group delivered on Public Subnets and internet-facing Load Balancer
The following image illustrates how this POC works, in general, and what is required to test the application:

![image](/images/public-subnets-internet-facing-lb.jpg)

This probably is the most appropriate arquitecture for services to be accessed by customers like applications front-end.
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

## Running the application on Visual Code

<br>
The following commands should be use to execute the Python app inside the VC:<br>
<br>

``` bash
cd "${CONTAINER_PATH}/APL-HelloWorld"
python3 app.py
```
<br>

# Packaging a Helm Chart
As detailed before, the simple Hello World application was created on the folder APL-HelloWorld.<br>
Basically the application will expose the <span style="color: Chocolate;">Hostname</span> and the <span style="color: Chocolate;">Service Type</span> that was passed to the application using the <span style="color: Chocolate;">values.yaml</span>.<br>

![image](/images/hello-world.jpg)
<br><br>


## Creating the new Helm Chart folder to use
<br>
The document <span style="color: Chocolate;">C:\WORK\CONHECIMENTO\DOCS\Kubernetes\Helm\helm.docx</span>, on the Knowledge Base, holds the detailed knowledge about Helm.<br>
For the purpose of this POC we will detail the procedure that was followed to create a new Helm Chart <span style="color: Chocolate;">HLM-HelloWorld</span>.
<br><br>
We used the following commands to create a new Helm Chart to be used by this POC:
<br><br>

``` bash
cd "${CONTAINER_PATH}"
helm create HLM-HelloWorld
```
<br>
The following folder/files structures will be created by the helm create:<br><br>

![image](/images/helm-create.jpg)

In the case os this POC we will create a very basic helm chart using only the <span style="color: Chocolate;">templates</span> folder and the <span style="color: Chocolate;">values.yaml</span>.<br>
On the templates folder, we will use only 3 manifests:
<br>
*	<span style="color: Chocolate;">Deployments</span>: which is used to release your application code.
*	<span style="color: Chocolate;">Services</span>: which is used to route traffic internally to your code.
*	<span style="color: Chocolate;">Ingress</span>: resources route external traffic into the cluster to your code.
<br><br>


## Packaging the Helm Chart locally
<br>

1. The first step to create an application Helm Chart is to develop the manifests like: <span style="color: Chocolate;">template.yaml</span>, <span style="color: Chocolate;">services.yaml</span>, <span style="color: Chocolate;">ingress.yaml</span>.<br>
In this POC, the manifests is very simple.<br>
Basically we use only some variables on the <span style="color: Chocolate;">values.yaml</span> to customize how our application will works. In our case, we will use the same Helm Chart to expose 3 different services to the outside world. Each of then using: <span style="color: Chocolate;">ClusterIP</span>, <span style="color: Chocolate;">NodePort</span> and <span style="color: Chocolate;">LoadBalance</span>.<br>

2. The second is creating the application image using docker build.<br>
Once the the image was created (<span style="color: Chocolate;">check it with docker image ls</span>) you are ready to package your Helm Chart.<br>

3. Use the following procedure to package your Helm Chart:
<br>
``` bash
cp "${CONTAINER_PATH}/HLM-HelloWorld/Chart-orig.yaml" "${CONTAINER_PATH}/HLM-HelloWorld/Chart.yaml"
sed -i "s|"-Helm-Chart-Name-"|${_PREFIX_NAME}|g" "${CONTAINER_PATH}/HLM-HelloWorld/Chart.yaml"

helm package "${CONTAINER_PATH}/HLM-HelloWorld" --destination "${CONTAINER_PATH}/HLM-Package"
```
<br>

<span style="color: red;">NOTE</span>: we use the cp and sed commands to change the Helm Chart Package Name that will be created using the helm package.









