# Wormchain VPS

## Build Image Development - Packer Docker and GCP

This project provides methods for building and deploying VPS images using Packer and Google Compute Engine. The VPS follows the requirements defined in the [Wormhole Testing Machine Specification](SPECIFICATION.md) documentation.

### Initializing Environment with Packer Plugins

The `required_plugins` section of the `packer` block in the template file lists the required plugins that are needed when developing the machine image for this project.

After installing packer, navigate to this subdirectory and run the following commands to install the required plugins for this project:

```bash
# Initialize the Docker plugin
cd build/
packer init wormchain.docker.pkr.hcl
# Initialize the Google Compute Engine plugin
packer init wormchain.gcp.pkr.hcl
```

### Variable Preperation
cd wormchain/
The variables required by the Packer specification can be found in the [wormchain.variables.pkr.hcl](./build/wormchain.variables.pkr.hcl) file. The variables have  most of the values pre-defined in the [variables.hcl](./variables.hcl) file.

Some variables are not included in the repo by default, and must be defined beforehand and passed to the Packer build command. A template file is provided at [variables.secret.hcl.template](./variables.secret.hcl.template) for this purpose. Copy this file to `variables.secret.hcl` and fill in the values for the missing variables.

### Local Helper Scripts

There are two helper scripts provided for building the image locally in Docker and in Google Compute Engine. These scripts are used to build the image using the Packer template files and provide a wrapper around the packer build command to ensure the correct variables are passed to the build command.

The scripts are:

1. [build-image.docker.sh](./build-image.docker.sh) - Builds the image locally in Docker, mostly useful for testing the provisioning steps
2. [build-image.gcp.sh](./build-image.gcp.sh) - Builds the image in Google Compute Engine

### Local Development

The project provides a local development method for quickly spinning up a Docker image that attempts to match what will be built in the production GCP project. This will allow quick development iteration locally so that the image software requirements can be tested before attempting a build in the production GCP project.

After making changes to the docker.pkr.hcl file, run the following command to rebuild the docker image:

```
# Build the image using the local helper script, logs are written to log.txt in the current directory for inspection
cd wormchain/
./build-image.docker.sh

# Run the image for inspection if needed
docker run -it wormchain/wormchain-dev:latest /bin/bash
```

### Issues with the Local Docker Image

The docker image used during development is mostly intended for speeding up writing the inline shell script that will be used to build the image. Due to the following requirements for this project, it is likely you will have trouble running this Docker image for local development:

1. Wormchain dev testing requires Tilt
2. Tilt requires a kubernetes cluster
3. kubernetes requires Docker containers
4. Docker in Docker is a difficult (but not impossible) problem to solve - See solutions like the official Docker [blog post](https://www.docker.com/blog/docker-can-now-run-within-docker/) about Docker-in-Docker

This project is not currently pushing for a local development container.

### Building the Image - Google Compute Engine

The project provides a method for building the image in Google Compute Engine.

After making changes to the wormchain.gcp.pkr.hcl file, run the following command to build the image:

```bash
# Build the image using the local helper script, logs are written to log.txt in the current directory for inspection
cd deploy/
./build-image.gcp.sh

# The image will be built in the GCP project, navigate to your GCP project to see the image
```