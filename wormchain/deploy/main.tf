module "wormhole_dev_machine" {
  for_each = var.developers
  source = "../../gcp-vps"
  project_name = var.project_name
  machine_name_postfix = each.value
  machine_type = var.machine_type
  boot_machine_image = var.project_name
  zone = var.gcp_zone
  ssh_username = var.ssh_username
  user_pubkey = var.user_pubkey
  tags = [var.project_name]
}

resource "google_compute_firewall" "wormchain_dev_ingress" {
  name    = "${var.project_name}-custom-ingress"
  network = "default"

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = [
      "22", # SSH
      "10350", # tilt server
    ]
  }

  source_ranges = var.ingress_cidr_ranges
  target_tags  = [var.project_name]
}
