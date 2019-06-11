#!/bin/bash
# Bootstraps a Ansible controller EC2 instance.
#
# This is optional but highly recommended.
# The bootstrap operation can be done directly on the Ops box. (Ignore the ssh parts bellow)
#
# Using a controller on AWS has the following benefits:
# * It speeds up the start up of the platform
# * Uses a vanilla instance, thus validating the whole install process across users.
# * Prepare the path to use this controller in a Ansible pull mode

# As an Ops:
# 0. Prepare the AWS credentials and the IAM role to assign to the controller in ~/.aws-env
#    This file is not copied to AWS. The IAM role is used instead.
#
#    export AWS_ACCESS_KEY_ID=
#    export AWS_SECRET_ACCESS_KEY=
#    export AWS_IAM_ROLE=

# 1. Prepare the AWS region  in ~/.aws-region
#    export AWS_DEFAULT_REGION=us-east-1
#
# 2. Prepare AIP specific settings in ~/.aip-aws
#    WIN_ADMIN_PASSWORD=somePasswordForAdmin123!
#    PUBLIC_KEY=
#    s3_BUCKET=
#    CAST_AIP_VERSION=
#    CAST_FLAT_AIP_ZIP=
#    CAST_AIP_CONSOLE_VERSION=
#    CAST_AIP_CONSOLE_BUILD_NUMBER=
#
# 3. Upload artifacts to a s3 bucket
#    Cast aip release, Cast aip flat (optional), Cast aip console
#
# 4. Prepare the ssh agent. Typically:
#    $>eval $(ssh-agent)
#    $>ssh-add <path to the in use private key>
#
#    This is the paired private key of the public key defined in ~/.aip-aws as PUBLIC_KEY
#
# 5. Spawn the controller instance
#    $>source ~/.aws-env
#    $>./aws_aip-control.sh
#
# 1. (Deprecated) Copy credentials and region to controller machine (~/.aws-env)
#    Note: Replace this with a AWS IAM role assignement
#    This has been replaced with the AWS_IAM_ROLE

# 1. Copy ~/.aip-aws to controller machine
#
# 2. Bootstrap on the control machine.
#    $>ssh -A admin@<controller-public-ip> ./bootstrap.sh
#
# 3. (In dev phase), iterate by updating the controller
#    $>./aws_aip-control.sh -t sync
#
# 4. (In dev phase), run the expansion of only one type of instance, then provision
#    $>ssh -A admin@<controller-public-ip> ./aws_aip-expand.sh -t <aipconsole|aipdashboard|aippostgres>
#    $>ssh -A admin@<controller-public-ip> ./aws_aip-<postgres|console|dashboard>.sh

# 5. AIP node, respond to aws_aip-scale.sh
#

# shellcheck disable=SC1090
[[ -f "$HOME/.aws-env" ]] && source "$HOME/.aws-env"
# shellcheck disable=SC1090
[[ -f "$HOME/.aws-region" ]] && source "$HOME/.aws-region"
# shellcheck disable=SC1090
[[ -f "$HOME/.aip-aws" ]] && source "$HOME/.aip-aws"

#playbook yo use
export PLAYBOOK="provision/bootstrap.yml"

PUBLIC_KEY=${PUBLIC_KEY:?"Missing public key path"}
[[ ! -f $PUBLIC_KEY ]] && echo "Public key file missing: $PUBLIC_KEY" && exit 1

EXTRA_VARS="public_key=$PUBLIC_KEY instance_profile_name=$AWS_IAM_ROLE" \
    ./aws_aip.sh -i bootstrap.ini -i inventory.aws_ec2.yml "$@"
./aws_aip.sh -i inventory.aws_ec2.yml --limit "aip_aws_controller_hosts:&expand" "$@"
./aws_inventory.sh --graph
