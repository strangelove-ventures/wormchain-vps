packer {
  required_plugins {
    docker = {
      version = ">= 1.0.10"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:22.04"
  commit = true
}

build {
  name    = "wormchain_docker"
  sources = [
    "source.docker.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y sudo",
      "useradd -m -s /bin/bash -G sudo ${var.ssh_username}",
    ]
    inline_shebang = "/bin/bash"
  }

  provisioner "shell" {
    script = "${var.provision_scripts_path}/core.sh"
  }

  provisioner "shell" {
    script = "${var.provision_scripts_path}/dev_user_ssh.sh"
    environment_vars = [
      "DEV_PUBKEY=${var.user_pubkey}",
      "DEV_USERNAME=${var.ssh_username}",
    ]
  }

  provisioner "shell" {
    script = "${var.provision_scripts_path}/languages.sh"
    environment_vars = [
      "GO_VERSION=1.22.6",
      "RUST_VERSION=stable",
    ]
  }

  provisioner "shell" {
    script = "${var.provision_scripts_path}/containers.sh"
    environment_vars = [
      "DOCKER_ENABLED=true",
      "K8S_ENABLED=true",
    ]
  }

  provisioner "shell" {
    inline = [
      "set -euox pipefail",
      "curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash",
      "git clone https://github.com/wormhole-foundation/wormhole.git /home/${var.ssh_username}/wormhole"
    ]
    inline_shebang = "/bin/bash"
  }

  provisioner "file" {
    source = "${var.upload_scripts_path}/wormchain-start-minikube"
    destination = "/tmp/wormchain-start-minikube"
  }

  provisioner "file" {
    source = "${var.upload_scripts_path}/wormchain-start-tilt"
    destination = "/tmp/wormchain-start-tilt"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/wormchain-start-minikube /usr/local/bin/",
      "sudo chmod +x /usr/local/bin/wormchain-start-minikube",
      "echo 'wormchain-start-minikube installed'",
      "sudo mv /tmp/wormchain-start-tilt /usr/local/bin/",
      "sudo chmod +x /usr/local/bin/wormchain-start-tilt",
      "echo 'wormchain-start-tilt installed'",
    ]
  }

  post-processor "docker-tag" {
    repository = "wormchain/${var.project_name}"
    tags = ["latest"]
  }
}


