#!/bin/bash
./aws_aip.sh -i bootstrap.ini -i inventory.aws_ec2.yml --limit localhost "$@"
./aws_aip.sh -i inventory.aws_ec2.yml --limit aip_aws_controller_hosts "$@"
./aws_inventory.sh --graph
