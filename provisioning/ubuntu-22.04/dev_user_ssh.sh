#!/bin/bash
set -euox pipefail

# User setup
sudo usermod -aG sudo ${DEV_USERNAME}

# SSH setup, this currently doesn't work as expected in GCE due to the way the SSH daemon is configured (it overrides authorized_keys), see https://cloud.google.com/compute/docs/instances/ssh
mkdir -p /home/${DEV_USERNAME}/.ssh
touch /home/${DEV_USERNAME}/.ssh/authorized_keys
chown -R ${DEV_USERNAME}:${DEV_USERNAME} /home/${DEV_USERNAME}/.ssh
chmod 700 /home/${DEV_USERNAME}/.ssh
chmod 600 /home/${DEV_USERNAME}/.ssh/authorized_keys

echo "${DEV_PUBKEY}" > /home/${DEV_USERNAME}/.ssh/authorized_keys

sudo systemctl enable ssh.service
