variable "gcp_project_id" {
  type = string
}

variable "developers" {
  type = set(string)
  default = []
  description = "A list of developers (by first name) to create machines for in the wormchain project. The machine name will be postfixed with each developer's name."

  validation {
    condition = alltrue([for name in var.developers : can(regex("^[a-zA-Z]+$", name))])
    error_message = "Developer names must contain only letters."
  }
}

variable "machine_type" {
  type = string
  default = "e2-standard-2"
}

variable "project_name" {
  type = string
}

variable "gcp_zone" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "user_pubkey" {
  type = string
}

variable "ingress_cidr_ranges" {
  type = list(string)
  default = ["0.0.0.0/0"]
}
