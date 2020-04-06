#!/bin/bash -x
# Set the AWS credentials and region in ~/.aws-env

# playbook to use
PLAYBOOK=${PLAYBOOK:-provision/aws_aip.yml}

# TODO
# Review this settings when implementing a log collector for AIP.
# hard coded logcollectors
EXTRA_VARS="${EXTRA_VARS} logcollector_host=172.31.77.11 logcollector_port=5044"

# shellcheck disable=SC1090
[[ -f "$HOME/.aws-env" ]] && source "$HOME/.aws-env"
# shellcheck disable=SC1090
[[ -f "$HOME/.aws-region" ]] && source "$HOME/.aws-region"
AWS_REGION=${AWS_DEFAULT_REGION} \
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:?Missing AWS_DEFAULT_REGION} \
ansible-playbook -e "$EXTRA_VARS"  "$@" "$PLAYBOOK"
