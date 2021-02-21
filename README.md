# Craft-Demo-PaloAlto

This repo has codes to do the follwong tasks:

1. Provision an EKS cluster in AWS along with VPCs, Self-Managed Node Group with 2 Instances, 1 separate Bastion EC2 Instance and Application Load Balancer to route Traffic to the EKS nodes.

2. A golang web-application, which is compiled to a docker image, docker image is pushed to image registry and a helm chart deploys the image to the EKS cluster as a deployment, along with HPA and Nodeport service


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

8. Run "aws configure" and configure credentials and region. Please note that region should be set to where the infra is to be provisioned


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
3. Verify the webapp deployment by running below command and the webapp demo-app should show here
   kubectl get deployment
5. Also verify hpa by running
   kubectl get hpa
7. Once confirmed fetch the ALB DNS name by running below command
   terraform Output
8. Open a browser and browse to the website
9. A static web content should welcome you.

Note: Please replace the placeholders <> with actual values




