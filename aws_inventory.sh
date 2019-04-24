#!/bin/bash
# shellcheck source=/dev/null
[[ -f $HOME/.aip-aws ]] && source "$HOME/.aip-aws"
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?Missing AWS_ACCESS_KEY_ID} \
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?Missing AWS_SECRET_ACCESS_KEY} \
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:?Missing AWS_DEFAULT_REGION} \
ansible-inventory -i inventory.aws_ec2.yml "$@"
