variable "project_name" {
  description = "A development project name the instance is associated with. Will be included in the instance tags and name."
  type        = string
}

variable "machine_name_postfix" {
  description = "The postfix to use for the instance name."
  type        = string
}

variable "machine_type" {
  description = "The machine type to use for the instance."
  type        = string
}

variable "boot_machine_image" {
  description = "The boot image to use for the instance."
  type        = string
}

variable "zone" {
  description = "The zone to create the instance in."
  type        = string
}

variable "ssh_username" {
  description = "The username to create on the instance for SSH access."
  type        = string
}

variable "user_pubkey" {
  description = "The public key to use for SSH access to the instance."
  type        = string
}

variable "tags" {
  description = "The tags to apply to the instance."
  type        = list(string)
  default     = []
}