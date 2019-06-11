#!/bin/bash
# shellcheck disable=SC1090
[[ -f "$HOME/.aws-env" ]] && source "$HOME/.aws-env"
# shellcheck disable=SC1090
[[ -f "$HOME/.aws-region" ]] && source "$HOME/.aws-region"
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:?Missing AWS_DEFAULT_REGION} \
ansible-inventory -i inventory.aws_ec2.yml "$@"
