resource "google_compute_instance" "gcp_vps" {
  name = "${var.project_name}-${var.machine_name_postfix}"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.tags
  boot_disk {
    initialize_params {
      image = var.boot_machine_image
    }
  }

  # TODO: Need to pass network options based on project requirements (e.g. SSH access, HTTP access, locked down to VPN only)
  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${var.user_pubkey}"
  }

  labels = {
    "project" = var.project_name
  }
}