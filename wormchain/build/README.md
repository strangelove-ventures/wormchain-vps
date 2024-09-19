# Wormchain VPS

This sub-project defines an Infrastructure-As-Code project for building a Google Machine Image according to the specification in the [Wormhole Testing Machine Specification](../SPECIFICATION.md) documentation.

## Requirements

This project was initially deployed using the following software:

* Packer v1.11.1
* Docker 27.0.3
* [`docker`](https://github.com/hashicorp/packer-plugin-docker) Packer plugin >= v1.0.10
* [`googlecompute`](https://github.com/hashicorp/packer-plugin-googlecompute/) Packer plugin >= v1.1.5

### Development Resources

The following resources were used during development:

* [Packer Docker Integration](https://developer.hashicorp.com/packer/integrations/hashicorp/docker)
* [Packer Docker Builder](https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/builder/docker)
* [Packer Provisioner Tutorial - Uses Docker](https://developer.hashicorp.com/packer/tutorials/docker-get-started/docker-get-started-provision)
* [Packer Shell Provisioner Guide](https://developer.hashicorp.com/packer/docs/provisioners/shell) - For running scripts that provision image during build
* [Packer Docker Tag Post-Processor](https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/post-processor/docker-tag)
* [Packer Variables](https://developer.hashicorp.com/packer/guides/hcl/variables)
