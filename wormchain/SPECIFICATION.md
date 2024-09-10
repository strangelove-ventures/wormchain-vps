# Wormhole Testing Machine Specification

An overview of development requirements for the team to test changes to the Wormhole repositories in a known, common environment.

## Overview

The machines should have the following general specification:

* A well-known Linux distribution as a base image to avoid issues with package availability and compatibility
* Extensions to the base image to support a common set of tools and libraries to ensure that the testing environment is consistent
* A network configuration that allows
  * Ingress over a known IP range
  * Any egress
  * Ports open to access over SSH and any other port required for testing
* Easily reproducible/deployable
  * The image should be able to be created from a script or configuration file
  * The machine should be able to be deployed from a script or configuration file

## Base Image

Ubuntu LTS will probably be good enough for this purpose.

## Software Extensions

### Required

* OpenSSH Server
  * For access to the machine
* Go Latest
  * For building wormchaind
* Rust Latest
  * For building wormhole contracts
* [Tilt](https://docs.tilt.dev/)
  * Wormchain testing uses Tilt for multi-network environment deployment and testing
* Kubernetes
  * Tilt uses Kubernetes to deploy the multi-network environment
* Docker
  * Tilt uses Docker to build the containers deployed to Kubernetes

## Possible

* NodeJS LTS
  * There are some Node scripts throughout the Wormchain repo, I am not sure if we will need to run them on the testing machines

## Nice to Have

* zsh or some other alternative to bash
  * Personal preference

## Network Configuration

* Ingress over a known IP range
  * The machines will need to be available for development access but not available to the public
* Any egress
  * The machines will need to be able to access the internet to download dependencies
* Some ports will require access for testing, such as:
    * RPC ports for wormchaind
    * [Tilt UI](https://docs.tilt.dev/tutorial/3-tilt-ui) over HTTP - this provides a web interface for monitoring the Tilt environment as it runs tests

## Reproducibility/Deployability

* The base image for the machine should be built from a script or configuration file
  * This will allow us to recreate machines as needed
  * It will also allow extensions to made over time using source control
* The machine should be deployable from a script or configuration file so envrionments can be spun up quickly

## Possible Strategies

### GCP Compute Engine - Discussed in the Wormhole Testing Meeting

* Use GCP Compute Engine to create a base image
* Multiple, small Infrastructure-as-Code projects to configure/create/deploy the machines
  * One for the base image creation using [OS Images](https://cloud.google.com/compute/docs/images)
  * One for the machine deployment and network configuration

## GCP Machine Specifications

1. Machine Type - [E2](https://cloud.google.com/compute/docs/general-purpose-machines#e2_machine_types)
  * Offers lower cost but still powerful specs
  * Good for lower requirement development machines according to [this](https://cloud.google.com/blog/products/compute/choose-the-right-google-compute-engine-machine-type-for-you) product article
  