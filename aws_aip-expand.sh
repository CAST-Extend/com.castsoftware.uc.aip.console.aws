#!/bin/bash
./aws_aip.sh -i localhost "$@"
./inventory.aws_ec2.sh --graph
