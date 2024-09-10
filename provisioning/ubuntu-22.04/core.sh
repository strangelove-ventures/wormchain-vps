#!/bin/bash
set -euox pipefail

sudo apt-get update
sudo apt-get upgrade -y

# provisioner pre-requisites
sudo apt-get install -y git curl apt-transport-https ca-certificates gnupg wget sudo openssh-server openssh-client build-essential
