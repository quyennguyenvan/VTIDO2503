packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_default_region" {
    default = "ap-southeast-1"
}

variable "aws_default_profile_name"{
    default = "quyennvdotcom"
}

variable "image_name" {
  default = "excersice_packer"
}

variable "aws_account_id" {
  default = "099720109477"
}
source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws"
  instance_type = "t2.micro"
  region        = var.aws_default_region
  profile        = var.aws_default_profile_name
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = [var.aws_account_id]
  }
  ssh_username = "ubuntu"
}

build {
  name    = var.image_name
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
        "sleep 10 && echo 'Install requirement component and services'",
        "sudo apt-get update -y",
        "sudo apt-get install -y nginx curl nano",
        "sudo apt-get update",
        "sudo apt-get install -y jq curl",
        "sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq",
        "sudo chmod +x /usr/local/bin/yq",
        "yq --version",
        "jq --version",
        "sudo apt-get update",
        "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release",
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
        "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
        "sudo apt-get update",
        "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
        "sudo systemctl enable docker",
        "sudo usermod -aG docker ubuntu"
    ]
  }

  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
    custom_data = {
      image_name = "${var.image_name}"
    }
  }
}

