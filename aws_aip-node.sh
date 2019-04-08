#!/bin/bash
./aws_aip.sh -i inventory.aws_ec2.yml --limit aip_node_hosts "$@"
