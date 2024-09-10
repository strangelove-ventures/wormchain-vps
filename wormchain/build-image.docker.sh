# TODO: add way to name image with unique name (e.g. with git commit hash or timestamp of creation)
# See docs on only flag: https://developer.hashicorp.com/packer/docs/templates/hcl_templates/onlyexcept
packer build -var-file="variables.hcl" \
  -var-file="variables.secret.hcl" \
  -color=false \
  -only="wormchain_docker.*" \
  build/ > log.txt