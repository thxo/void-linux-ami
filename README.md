# Void Linux on AWS

These scripts build a fresh AWS EC2 AMI image for [Void Linux](https://voidlinux.org/) using [Packer](https://www.packer.io/).

After an EC2 instance is launched, log in with `ec2-user` with the SSH key selected during provisioning. The user has sudo access.

## Prerequisites
1. AWS account, with an access key generated ([link to IAM](https://console.aws.amazon.com/iam/home?#security_credential) to do so).
2. Packer installed ([instructions](https://learn.hashicorp.com/packer/getting-started/install)).

## Steps
1. Export AWS environment variables.
```sh
$ export AWS_ACCESS_KEY_ID=ASAMPLESAMPLEEXAMPLE
$ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
$ export AWS_DEFAULT_REGION=us-west-2
```

2. Build with packer:
```sh
$ packer build void-ec2.json
[...omitted...]
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebssurrogate: AMIs were created:
us-west-2: ami-00f66cafecafecafe
```

You can now find the AMI in "My AMI" when you launch an instance.