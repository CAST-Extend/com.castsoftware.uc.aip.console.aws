## Requirements

One must have AWS tokens with permission to launch ec2 instances,
create security groups.

For the moment we also assume a subnet 172.31.64.0/20 exists.
(private ips are hard coded)

## Environment variables to set in `~/.aip_aws`

`
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION
WIN_ADMIN_PASSWORD
PRIVATE_KEY
`

One can also export them in the current shell session before calling the scripts

## Bake the CAIP Windows node - `./aws_aip-bake.sh`

Since the install of CAIP is *very* long,
the purpose of baking an image is to reduce the setup duration of nodes.

Each node will receive only the install of the api layer.

### What it does?
Starts a Windows (ami-0410d3d3bd6d555f4) and install the current version of CAIP.

The CAIP tarball must be previously uploaded to a s3 bucket

After a successful install a ami image with the same version is created for later use.

## Expand - `./aws_aip-expand.sh`

The machines to launch are of different types
A type is a tuple (ami, instance size)

aippostgres (deb strech, t2.micro)
aipnode (previously basked win2019, t2.small)
aipconsole (deb strech, t2.micro)

Expansion launches a given number of machines for each type:

1 aippostgres
2 aipnode
1 aipconsole

## Init - `./aws_aip-postgres.sh && ./aws_aip-node.sh && ./aws_aip-console.sh`

Each machine type has a particular initialisation process

### aippostgres
Installs postgres and the required roles for aip nodes

### aipnode
Installs the aip api and fetches the created tokens

### aipconsole
Installs the aip console and configure known nodes


## Adding new nodes

To add new aip nodes we go through expand and init again after adjusting the node count

### Adding new nodes - expand - `EXTRA_VARS="aip_node_count=3" ./aws_aip-expand.sh -t aipnode` 

### Adding new nodes - init - `./aws_aip-node.sh` 

Only newly expanded node are inited.
The tokens are also fetched.

### Update the console - `./aws_aip-console.sh -t aipnode`

Registers new nodes with tokens

### Putting it all together `./aws_aip-scale.sh <node_count>`

## Removing nodes - TODO

