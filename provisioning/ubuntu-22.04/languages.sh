#!/bin/bash
set -euox pipefail


if [ -z "${GO_VERSION}" ]; then
  echo "GO_VERSION is not set, skipping"
else
  # Go installed with version, leave out the prefix "v", path is added to /etc/profile.d/init_go.sh which runs on any user login
  wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
  rm go${GO_VERSION}.linux-amd64.tar.gz
  echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile.d/init_go.sh
  sudo chmod +x /etc/profile.d/init_go.sh
fi

if [ -z "${RUST_VERSION}" ]; then
  echo "RUST_VERSION is not set, skipping"
else
  # Rust, may need to ask Marc for best practices in downloading/installing rust automated
  curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain ${RUST_VERSION}
fi
