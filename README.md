
# AIP on demand AWS enabler

Spawns a ready to go AIP platform on AWS.

This set up comprises:

* AIPConsole
* CAST AIP
* Dashboard
* Postgres RDBMS

With CAST AIP being the only component to scale out once the platform is spawned.

The Postgres instance is shared by all components.

## Primary use case - platform with 2 AIP nodes, within minutes

1. Spawn a platform with 2 CAST AIP nodes in a given subnet in AWS, within minutes.
2. Run projects analysis (manual)
3. Grab results (manual)
4. destroy platform

### Future use cases ?

Upload zip of source files to be analyzed through an AIPConsole endpoint and push the result (a Postgres dump?) to AWS s3.

## Requirements

AWS tokens with permissions to launch ec2 instances,
create security groups and have read access to a given s3 bucket.

A VPC subnet id with its CIDR specification. (todo: describe overriding values in aws-defaults.yml)

### Environment variables to set in `~/.aip_aws`

```bash
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION
WIN_ADMIN_PASSWORD
PUBLIC_KEY
```

AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY: These are your AWS credential tokens

AWS_DEFAULT_REGION: AWS region to use.

WIN_ADMIN_PASSWORD: Windows Administrator password (similar to myTempPassword123!)

PUBLIC_KEY: Path to public key to use for ssh authentication on Linux machines

You can also export those variables in the current shell session instead.


### CAST Artifacts

* CAST_AIP_xxx.zip
* AIP-Console-xxx.zip(>1.9 with the CAST-RESTAPI-integrated.war)

#### Patching AIP-Console-xxx.zip

Extract the zip, then extact the CAST-RESTAPI-integrated.war

patch the file WEB-INF/domains.properties with the line
AAD=Resource1,general_measure

Explanation:

There is a context parameter entry in the web.xml for *domains-location*, which is 
used as virtual path under the servlet context and cannot be overridden with an external path.


## Upload artifacts to s3

Following artifacts must be uploaded to s3:

* CAST_AIP_xxx.zip
* AIP-Console-xxx.zip 

To upload those file, it is recommended to install the aws cli.
It is much faster and less prone to errors than with the web console.

```bash
aws s3 <path to zip> s3://<bucket>
```
## Optional (but recommended) control VM - ./aws_aip-bootstrap.sh

Creates a ec2 VM to assume the ansible control machine role.

This is optional, but it is much faster to run inside AWS.
It also validates the install from scratch of a control machine.

if not using the bootstrap method, install the requirements locally with `install_ansible_requirements.sh`

Note that for the moment, you must copy the ~/.aip-aws on the controller machine.
This must be replaced by a AWS IAM Role, and this step will remain there to remind you that!

### SSH agent

All launched Linux machines share the same installed public key for authentication ( the one above )
Use ssh with agent forwarding if you choose to bounce on the ansible controller machine in AWS.


## Bake the CAIP Windows node - `./aws_aip-bake.sh`

Since the install of CAIP is *very* long,
the purpose of baking an image is to reduce the setup duration of nodes,
  since the AIP install is already done.

The setup of each node requires only the install of AIP-Console to configure the api access

### What it does?

Starts a Windows (ami-0410d3d3bd6d555f4) and install CAIP from s3.

After a successful install an AMI image with the same version is created for later use.

## Expand - `./aws_aip-expand.sh`

Creates the platform (VMs + Network configuration) to host AIP related artifacts.

The VMs to launch are of different types (ami, instance size)

aippostgres (deb strech, t2.micro)
aipnode (previously basked win2019, t2.small)
aipconsole (deb strech, t2.micro)

Expansion launches a given number of machines for each type:

1 aippostgres
2 aipnode
1 aipconsole

## Init - `./aws_aip-postgres.sh && ./aws_aip-node.sh && && ./aws_aip-dashboard.sh ./aws_aip-console.sh`

Initialize the VMs, given its type.

### aippostgres
Installs postgres and the required roles for aip nodes.
Restore the dump to use with dashboard

### aipnode
Installs the aip api and fetches the created tokens

### aipdashboard 
Intalls the aip war to use with the console.

### aipconsole
Installs the aip console and configure known aip nodes and dashboard integration.


## Adding new nodes

To add new aip nodes:

* adjust total aip node count
* expand
* init aip nodes
* update the console

### Adding new nodes - expand - `EXTRA_VARS="aip_node_count=3" ./aws_aip-expand.sh -t aipnode` 

### Adding new nodes - init - `./aws_aip-node.sh` 

Only newly expanded node are inited.
The tokens are also fetched.

### Update the console - `./aws_aip-console.sh -t aipnode`

Registers new nodes with tokens

### Putting it all together `./aws_aip-scale.sh <node_count>`

## Removing nodes - TODO

