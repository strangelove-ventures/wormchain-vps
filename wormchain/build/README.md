# Wormchain Build

This sub-project defines an Infrastructure-As-Code project for building a Google Machine Image according to the specification in the [Wormhole Testing Machine Specification](../Wormhole%20Testing%20Machine%20Specification.md) documentation.

## Requirements

This project was initially deployed using the following software:

* Packer v1.11.1
* Docker 27.0.3
* [`docker`](https://github.com/hashicorp/packer-plugin-docker) Packer plugin >= v1.0.10
* [`googlecompute`](https://github.com/hashicorp/packer-plugin-googlecompute/) Packer plugin >= v1.1.5

## Build Image Development Development

### Initializing Environment with Packer Plugins

The `required_plugins` section of the `packer` block in the template file lists the required plugins that are needed when developing the machine image for this project.

After installing packer, navigate to this subdirectory and run `packer init <path to template file>` to download the plugins to prepare for building and deploying the image.

### Local Development

The project provides a local development method for quickly spinning up a Docker image that attempts to match what will be built in the production GCP project. This will allow quick development iteration locally so that the image software requirements can be tested before attempting a build in the production GCP project.

After making changes to the docker.pkr.hcl file, tun the following command to rebuild the docker image:

```
# Build the image
packer build wormchain.docker.pkr.hcl

# Run the image for inspection if needed
docker run -it wormchain/wormchain:latest /bin/bash
```

### Issues with the Local Docker Image

The docker image used during development is mostly intended for speeding up writing the inline shell script that will be used to build the image. Due to the following requirements for this project, it is likely you will have trouble running this Docker image for local development:

1. Wormchain dev testing requires Tilt
2. Tilt requires a kubernetes cluster
3. kubernetes requires Docker containers
4. Docker in Docker is a difficult (but not impossible) problem to solve - See solutions like the official Docker [blog post](https://www.docker.com/blog/docker-can-now-run-within-docker/) about Docker-in-Docker

This project is not currently pushing for a local development container.

### Development Resources

The following resources were used during development:

* [Packer Docker Integration](https://developer.hashicorp.com/packer/integrations/hashicorp/docker)
* [Packer Docker Builder](https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/builder/docker)
* [Packer Provisioner Tutorial - Uses Docker](https://developer.hashicorp.com/packer/tutorials/docker-get-started/docker-get-started-provision)
* [Packer Shell Provisioner Guide](https://developer.hashicorp.com/packer/docs/provisioners/shell) - For running scripts that provision image during build
* [Packer Docker Tag Post-Processor](https://developer.hashicorp.com/packer/integrations/hashicorp/docker/latest/components/post-processor/docker-tag)
* [Packer Variables](https://developer.hashicorp.com/packer/guides/hcl/variables)
