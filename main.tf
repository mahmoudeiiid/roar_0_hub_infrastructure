terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "hub" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name = var.instance_key_pair
  iam_instance_profile = var.instance_role
   user_data = <<EOF
    #!/bin/bash
    yum update
    yum install git -y 
    git clone 
    git clone
    git clone
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform
    curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl
    curl -o kubectl.sha256 https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl.sha256
    chmod +x ./kubectl
    mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
    echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
    kubectl version --short --client
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin
    eksctl version
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    helm repo add datadog https://helm.datadoghq.com
    helm install my-datadog-operator datadog/datadog-operator
    kubectl create secret generic datadog-secret --from-literal api-key=994130da167b5f900066198c8946d482 --from-literal app-key=dcea55d1fd05011fb33278596b02b663b70edc8c

    EOF
  tags = merge(
    var.additional_tags,
    {
      Name = "EC2_Roar_Hub"
    },
  )
}
output "login" {
  value = join("@",["ec2-user",aws_instance.hub.public_ip])
}