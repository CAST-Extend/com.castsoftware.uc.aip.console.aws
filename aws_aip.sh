#!/bin/bash
# Env vars to set in ~/.aip-aws (or set in current session):
#
# AWS Credentials and default region
# You must have permission:
#  - to launch/destroy ec2 instance
#  - create security groups
#####
#AWS_ACCESS_KEY_ID=
#AWS_SECRET_ACCESS_KEY=
#AWS_DEFAULT_REGION=us-east-1
#####
#
# Windows Admin password
#####
#WIN_ADMIN_PASSWORD=
#####
#
# SSH Linux instances (key only)
# Private key for ssh on Linux machine
# ( public key is $PRIVATE_KEY.pub )
#####
#PRIVATE_KEY=~/.ssh/id_rsa
#####
#

# shellcheck source=/dev/null
[[ -f $HOME/.aip-aws ]] && source "$HOME/.aip-aws"

# playbook to use
PLAYBOOK=${PLAYBOOK:-provision/aws_aip.yml}

PRIVATE_KEY=${PRIVATE_KEY:?Missing private key}
[[ -n "$WIN_ADMIN_PASSWORD" ]] && EXTRA_VARS="$EXTRA_VARS win_admin_password=$WIN_ADMIN_PASSWORD"
EXTRA_VARS="${EXTRA_VARS} private_key=$PRIVATE_KEY logcollector_host=172.31.77.11 logcollector_port=5044"

AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?Missing AWS_ACCESS_KEY_ID} \
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?Missing AWS_SECRET_ACCESS_KEY} \
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:?Missing AWS_DEFAULT_REGION} \
ansible-playbook -e "$EXTRA_VARS"  "$@" "$PLAYBOOK"
