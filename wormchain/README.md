# Wormchain VPS

## Image Overview

This project provides methods for building and deploying VPS images using Packer and Google Compute Engine. The VPS follows the requirements defined in the [Wormhole Testing Machine Specification](SPECIFICATION.md) documentation.

### Image Requirements - Wormchain Development

The image aims to provide a VPS that meets the requirements for the Wormhole Testing Machine Specification. The image should have the following software installed:

1. Docker
2. Tilt
3. Minikube
4. Go
5. Node.js
6. Rust

The image also provides a user `wormchain-dev` with the wormhole repo cloned in the home directory, which can be used to run the wormhole tests.

### Image Provisioning Scripts - Software Installation and Image Preparation

The image is provisioned using shell scripts that run on the machines. The scripts are located in the [`provisioning/ubuntu-22.04`](../provisioning/ubuntu-22.04/) directory and are used to install the required software on the machine.

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

### Variable Preparation

The variables required by the Packer specification can be found in the [wormchain.variables.pkr.hcl](./build/wormchain.variables.pkr.hcl) file. The variables have  most of the values pre-defined in the [variables.hcl](./variables.hcl) file.

Some variables are not included in the repo by default, and must be defined beforehand and passed to the Packer build command. A template file is provided at [variables.secret.hcl.template](./variables.secret.hcl.template) for this purpose. Copy this file to `variables.secret.hcl` and fill in the values for the missing variables.

```bash
cd wormchain/

# edit variables.hcl with any changes necessary for your environment

# copy the secrets file template to the correct location, which is ignored by git
cp variables.secret.hcl.template variables.secret.hcl

# fill out the variables.secret.hcl file with the values for your environment
```

### Local Helper Scripts

There are two helper scripts provided for building the image locally in Docker and in Google Compute Engine. These scripts are used to build the image using the Packer template files and provide a wrapper around the packer build command to ensure the correct variables are passed to the build command.

The scripts are:

1. [build-image.docker.sh](./build-image.docker.sh) - Builds the image locally in Docker, mostly useful for testing the provisioning steps
2. [build-image.gcp.sh](./build-image.gcp.sh) - Builds the image in Google Compute Engine

### Local Development - Docker Image

The project provides a local development method for quickly spinning up a Docker image that attempts to match what will be built in the production GCP project. This will allow quick development iteration locally so that the image software requirements can be tested before attempting a build in the production GCP project.

You can inspect the output of the helper script by looking at the `log.txt` output file. When the script successfully completes, images will be imported into the local Docker registry.

After making changes to the `build/wormchain.docker.pkr.hcl` file or the scripts used for provisioning the image, run the following command to rebuild the docker image:

```bash
# Build the image using the local helper script, logs are written to log.txt in the current directory for inspection
cd wormchain/
./build-image.docker.sh

# When the script finishes, inspect the log file for results
cat log.txt
```


#### **Successes**: Example Logs - Docker Image Built Successfully

When the build finishes successfully, the logs will show the image was built and imported into the local Docker registry.

```bash
Build 'wormchain_docker.docker.ubuntu' finished after 3 minutes 15 seconds.

==> Wait completed after 3 minutes 15 seconds

==> Builds finished. The artifacts of successful builds are:
--> wormchain_docker.docker.ubuntu: Imported Docker image: sha256:deb09293f0848728d1f8ae95f48f39156c4a1a2351950f1e7e191c7143fb026c
--> wormchain_docker.docker.ubuntu: Imported Docker image: wormchain/wormchain-dev:latest with tags wormchain/wormchain-dev:latest
```

Note the following:

1. Builds finished successfully, and artifacts were created
2. The Docker image was imported into the local Docker registry
3. The image was tagged as `wormchain/wormchain-dev:latest`

#### **Failures**: Example Logs - Docker Image Build Failed

When the build fails, the logs will show the error that caused the build to fail. In this example, the error was caused by a typo in the provisioning script.

```bash
==> wormchain_docker.docker.ubuntu: + sudo apt-get updat
==> wormchain_docker.docker.ubuntu: E: Invalid operation updat
==> wormchain_docker.docker.ubuntu: Provisioning step had errors: Running the cleanup provisioner, if present...
==> wormchain_docker.docker.ubuntu: Killing the container: 4904e9b3b3bf1f9eab2c67d106b204b4743a21aa4d10e9e7172816ac761dd860
Build 'wormchain_docker.docker.ubuntu' errored after 5 seconds 777 milliseconds: Script exited with non-zero exit status: 100. Allowed exit codes are: [0]

==> Wait completed after 5 seconds 777 milliseconds

==> Some builds didn't complete successfully and had errors:
--> wormchain_docker.docker.ubuntu: Script exited with non-zero exit status: 100. Allowed exit codes are: [0]

==> Builds finished but no artifacts were created.
```

Note the following:

1. The build errored out after 5 seconds 777 milliseconds
2. The script exited with a non-zero exit status: 100
3. The build did not complete successfully, and no artifacts were created

#### Inspecting the Docker Image

The image will be tagged as `wormchain/wormchain-dev:latest`.

```bash
# Run the image for inspection, see that the expected software was installed correctly
docker run -it wormchain/wormchain-dev:latest /bin/bash
root@abfdbbfb6b5f:/# which tilt
/usr/local/bin/tilt
root@abfdbbfb6b5f:/# which minikube
/usr/local/bin/minikube
root@abfdbbfb6b5f:/# cd home/wormchain-dev/

# The wormchain-dev user should have the wormhole repo cloned in the home directory
root@abfdbbfb6b5f:/home/wormchain-dev# ls wormhole/
CONTRIBUTING.md  Dockerfile.const  Makefile       SECURITY.md  aptos             buf.lock  cosmwasm                 dashboards   docs                  generate-abi.sh  node               relayer  solana  terra        tilt_modules  wormchain
DEVELOP.md       Dockerfile.proto  Makefile.help  Tiltfile     buf.gen.web.yaml  buf.yaml  cspell-custom-words.txt  deployments  ethereum              lp_ui            package-lock.json  scripts  spydk   testing      tools
Dockerfile.cli   LICENSE           README.md      algorand     buf.gen.yaml      clients   cspell.config.yaml       devnet       generate-abi-celo.sh  near             proto              sdk      sui     third_party  whitepapers
```

### **Warning**: Issues with the Local Docker Image

The docker image used during development is mostly intended for speeding up writing the inline shell scripts that will be used to build the image. Due to the following requirements for this project, it is likely you will have trouble running this Docker image for local development:

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

# When the script finishes, inspect the log file for results
cat log.txt
```

#### **Successes**: Example Logs - GCP Image Built Successfully

When the build finishes successfully, the logs will show the image was built in the GCP project.

```bash
Build 'wormchain_gcp.googlecompute.ubuntu' finished after 6 minutes 17 seconds.

==> Wait completed after 6 minutes 17 seconds

==> Builds finished. The artifacts of successful builds are:
--> wormchain_gcp.googlecompute.ubuntu: A disk image was created in the '<your project name here>' project: <your image name here>
```

Note the following:

1. Builds finished successfully, and artifacts were created
2. A disk image was created in the GCP project with the name `<your image name here>`

#### **Failures**: Example Logs - GCP Image Build Failed

```bash
==> wormchain_gcp.googlecompute.ubuntu: + sudo apt-get install -y git curl apt-transport-https ca-certificates gnupg wget sudo openssh-server openssh-client build-essential
    wormchain_gcp.googlecompute.ubuntu: Reading package lists...
    wormchain_gcp.googlecompute.ubuntu: Building dependency tree...
    wormchain_gcp.googlecompute.ubuntu: Reading state information...
==> wormchain_gcp.googlecompute.ubuntu: E: Package 'build-essential' has no installation candidate
    wormchain_gcp.googlecompute.ubuntu: Package build-essential is not available, but is referred to by another package.
    wormchain_gcp.googlecompute.ubuntu: This may mean that the package is missing, has been obsoleted, or
    wormchain_gcp.googlecompute.ubuntu: is only available from another source
    wormchain_gcp.googlecompute.ubuntu:
==> wormchain_gcp.googlecompute.ubuntu: Provisioning step had errors: Running the cleanup provisioner, if present...
==> wormchain_gcp.googlecompute.ubuntu: Deleting instance...
    wormchain_gcp.googlecompute.ubuntu: Instance has been deleted!
==> wormchain_gcp.googlecompute.ubuntu: Deleting disk...
    wormchain_gcp.googlecompute.ubuntu: Disk has been deleted!
Build 'wormchain_gcp.googlecompute.ubuntu' errored after 2 minutes 26 seconds: Script exited with non-zero exit status: 100. Allowed exit codes are: [0]

==> Wait completed after 2 minutes 26 seconds

==> Some builds didn't complete successfully and had errors:
--> wormchain_gcp.googlecompute.ubuntu: Script exited with non-zero exit status: 100. Allowed exit codes are: [0]

==> Builds finished but no artifacts were created.
```

Note the following:

1. The build errored out after 2 minutes 26 seconds
2. The script exited with a non-zero exit status: 100
3. The build did not complete successfully, and no artifacts were created

### Inspecting the GCP Image

The image will be built in the GCP project, navigate to your GCP project to see the image:

1. Log into the GCP console
2. Navigate to Compute Engine -> Images
3. The image will be named `wormchain-dev` (or whatever you have set for the project name in the `variables.hcl` file)
4. Click on the image to see the details
5. Use this image to spin up a new instance in the GCP project

### Using the GCP Image

The image built in the GCP project can be used to spin up a new instance in the GCP project. The instance will have the software requirements defined in the [Wormhole Testing Machine Specification](SPECIFICATION.md) documentation.

It also provides a user `wormchain-dev` with the wormhole repo cloned in the home directory, which can be used to run the wormhole tests.
