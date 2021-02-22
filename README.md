# Craft-Demo-PaloAlto

This repo has codes to do the following tasks:

1. Provisions an AWS EKS cluster with the below components:
    a. VPC
    b. Private and Public Subnets
    c. IGW, NGW and Route Tables
    d. EKS Cluster
    e. Launch Template and Autoscaling Group to launch Instances which will bootstrap to the EKS Control Plane
    f. An ALB which listens on port 80 and forwards traffic to the EKS nodes on nodeport 30080 
    f. One EC2 bastion Host to access the worker nodes which are running in Private Subnet

2. A golang web-application like below:
    a. The application is compiled with Go Lang
    b. A docker image is built with the Go code and pushed to registry
    c. A helm chart to deploy the web app
    d. The helm chart deploys the app deployment, a hpa and a nodeport service

3. A homebrewed simple CI/CD shell script which can:
    a. Compile small changes in the Go code located at PaloAlto-Craft-Demo/PaloAlto-Demo-App/app-code/http-sample.go
    b. Build a docker image based on these changes
    c. Push the image to a image registry
    d. Deploy/Upgrade the web app to the EKS cluster with helm install/upgrade


# Objective

Once both the code runs successfully the demo web-app should be returned if the ALB is queried in a browser


# Before you begin

Before you run the infrastructure provisioning or the webapp code please perform these pre-requisite steps on local development environment.

1. Install git
https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

2. Install terraform
https://learn.hashicorp.com/tutorials/terraform/install-cli

3. Install kubectl
https://kubernetes.io/docs/tasks/tools/install-kubectl/

4. Install awscli
https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html

5. Install go
https://golang.org/doc/install

6. Install eksctl
https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html

7. Install aws-iam-authenticator
https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html

8. Install helm
https://helm.sh/docs/intro/install/

9. Run "aws configure" and configure credentials and region. Please note that region should be set to where the infra is to be provisioned


# How to Use

The code is divided into two sub-directories, one for infrastructure provisioning and other for web-app deployment.

NOTE: Before the code is deployed please complete the pre-requisites from the previous section

# Instrastructure Provisioning

1. Clone this repo: git clone https://github.com/sayansaha911/PaloAlto-Craft-Demo.git
2. Navigate to PaloAlto-Demo-Infra directory
3. Run ssh-keygen and generate a key pair. This key pair will be used to access the EC2 instances
4. Create a secret.auto.tfvars file with the below content
    a. access_key = <aws programmatic access key>
    b. secret_key = <aws programmatic secret key>
    c. sh_key_data = <public key from step 3>
5. Deploy the infrastructure with Terraform by running the below commands
    a. terraform validate
    b. terraform init
    c. terraform plan
    d. terraform apply
6. Once the terraform run is complete verify the cluster by running "kubectl get nodes". The output should look like below:
NAME                          STATUS   ROLES    AGE   VERSION
ip-xxxxxxxxxx.ec2.internal   Ready    <none>   43m   v1.17.12-eks-7684af
ip-xxxxxxxxx.ec2.internal    Ready    <none>   43m   v1.17.12-eks-7684af


# Webapp provisioning
    
1. Once the infrstructure is provisioned, navigate to the PaloAlto-Demo-Infra/app-code directory

2. Compile the go code by running below and 
   GOOS=linux GOARCH=amd64 go build -tags netgo -o http-sample && cd ..
3. Then build the docker image and push it to image registry
   docker build -t <app-name>:<app-version> . && docker push <app-name>:<app-version>
5. Run the below command to provision the demo web-app on the EKS cluster
        helm install demo-app ./helm-install/. --set image.repository=<app-name>:<app-version>

6. OR Instead of running Steps 2,3 and 4, you can alternatively run the app-deploy.sh with the necessary inputs and it will do all those for you
7. Verify the webapp deployment by running "kubectl get deployment" and the webapp demo-app should show here
8. Also verify hpa by running "kubectl get hpa"
9. Once confirmed fetch the ALB DNS name by running "terraform output"
10. Open a browser and browse to the website
11. A static web content should welcome you

Note: Please replace the placeholders <> with actual values