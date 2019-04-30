#!/bin/bash
# Bootstraps a Ansible controller EC2 instance.
#
# This is optional and can be done directly on the Ops box. (Ignore the ssh parts bellow)
#
# Using a controller on AWS has the following benefits:
# * It speeds up the start up of the plateform
# * Uses a vanilla instance, thus validating the whole install process across users.
# * Prepare the path to use this controller in a Ansible pull mode

# As an Ops:
# 0. Prepare the ssh agent. Typically:
#    $>eval $(ssh-agent)
#    $>ssh-add <path to the in use private key>
#
#    This is the paired private key of the public key defined in ~/.aip-aws
#
# 1. Spawn the controller instance
#    $>./aws_aip-bootstrap.sh
#
# 2. Run the others script on the controller
#    $>ssh -A admin@<controller-public-ip> ./bootstrap.sh
#
# 3. (In dev phase), iterate by updating the controller
#    $>./aws_aip-bootstrap.sh -t sync
#
# 4. (In dev phase), run the expansion of only one type of instance, then provision
#    $>ssh -A admin@<controller-public-ip> ./aws_aip-expand.sh -t <aipconsole|aipdashboard|aippostgres>
#    $>ssh -A admin@<controller-public-ip> ./aws_aip-<postgres|console|dashboard>.sh
# 5. AIP node, respond to aws_aip-scale.sh
#

export PLAYBOOK="provision/bootstrap.yml"
./aws_aip.sh -i bootstrap.ini -i inventory.aws_ec2.yml "$@"
./aws_aip.sh -i inventory.aws_ec2.yml --limit "aip_aws_controller_hosts:&expand" "$@"
./aws_inventory.sh --graph
