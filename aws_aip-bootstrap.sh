#!/bin/bash
export PLAYBOOK="provision/bootstrap.yml"
./aws_aip.sh -i bootstrap.ini -i inventory.aws_ec2.yml "$@"
./aws_aip.sh -i inventory.aws_ec2.yml --limit "aip_aws_controller_hosts:&expand" "$@"
./aws_inventory.sh --graph
