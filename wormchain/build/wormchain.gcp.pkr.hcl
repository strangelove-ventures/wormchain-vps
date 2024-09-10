packer {
  required_plugins {
    googlecompute = {
      version = "1.1.5"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "ubuntu" {
  project_id   = "${var.gcp_project_id}"
  source_image = "ubuntu-2204-jammy-v20240801"
  ssh_username = "${var.ssh_username}"
  zone         = "${var.gcp_zone}"

  image_name    = "${var.project_name}"

  // TODO: What is the difference between image_labels and tags?
  image_labels = {
    "project" = var.project_name
  }

  tags = [
    "${var.project_name}"
  ]
}

build {
  name = "wormchain_gcp"
  sources = [
    "source.googlecompute.ubuntu"
  ]

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

  provisioner "shell" {
    inline = [
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ${var.ssh_username}",
    ]
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
}
