#!/bin/bash
./aws_aip.sh -i inventory.aws_ec2.yml --limit "aip_postgres_hosts:&expand" "$@"
