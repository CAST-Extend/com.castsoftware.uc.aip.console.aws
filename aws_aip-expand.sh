#!/bin/bash
./aws_aip.sh -i expand.ini "$@"
./aws_inventory.sh --graph
