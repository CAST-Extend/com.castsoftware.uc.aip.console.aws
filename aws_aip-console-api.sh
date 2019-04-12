#!/bin/bash
PLAYBOOK="provision/aws_aip_console_api.yml" \
./aws_aip.sh -i inventory.aws_ec2.yml --limit aip_console_hosts "$@"
