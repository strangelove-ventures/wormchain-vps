🌌 Why use Wormchain VPS?
=============================

ARM chips got ya down? This repo provides a project-oriented implementation of virtual private server specifications, including documentation, requirements and infrastructure-as-code projects for building and deploying common machines. 

🌌🌌 Who's it for?
=============================

`wormchain-vps` helps developers spin up VPS's.

🌌🌌🌌 What does it do?
=============================

The goal is to provide standardized, common machines for various projects that will allow developers to share an environment for development or testing, without needing to worry about the differences between development machines.


🌌🌌🌌🌌 How do I use it?
=============================

- See READMEs in the /build or /deploy folders (e.g `wormchain/build/README.md`) for usage instructions.

## Development Requirements

* `Terraform >= v1.9.2`
* `Packer v1.11.1`
* `gcloud 487.0.0`
  * Configured CLI for [authentication](https://cloud.google.com/sdk/docs/authorizing#choose-authz-type) to the GCP account

🌌🌌🌌🌌🌌 Extras
=============================

## Resources

* [Packer Getting Started Guide](https://developer.hashicorp.com/packer/tutorials/docker-get-started/docker-get-started-build-image)
* [Packer Build an Image Tutorial](https://developer.hashicorp.com/packer/tutorials/docker-get-started/docker-get-started-build-image) - Uses Docker
* [Google Compute Packer plugin](https://developer.hashicorp.com/packer/integrations/hashicorp/googlecompute) documentation
* [GCP OS Images](https://cloud.google.com/compute/docs/images) - What packer uses for deploying reusable VPS images
* [Packer Usage with Terraform](https://developer.hashicorp.com/terraform/tutorials/provision/packer)
* [Compute Engine Machine Type Explainer](https://cloud.google.com/blog/products/compute/choose-the-right-google-compute-engine-machine-type-for-you)
* [Compute Engine Machine Type Pricing](https://cloud.google.com/compute/all-pricing)
* [Compute Engine Instance Automated SSH Management](https://cloud.google.com/compute/docs/instances/ssh)
* [Compute Engine Instance Manual SSH Management](https://cloud.google.com/compute/docs/connect/add-ssh-keys)
  * [Instance Metadata SSH Manual Management](https://cloud.google.com/compute/docs/connect/add-ssh-keys#metadata)
  * [Instance Metadata SSH Manual Management - Terraform Deployment](https://cloud.google.com/compute/docs/connect/add-ssh-keys#terraform_2)
