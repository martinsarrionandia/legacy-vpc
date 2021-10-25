###
#Creates a Legacy VPC, infrastructure and IAM role for migrating ESXi guests to AMI images. Provides a bash script to migrate VMs 
###

# Requirements

* AWS Secret manager

  * https://aws.amazon.com/secrets-manager/

* sshpass

  * ```bash
    brew install esolitos/ipa/sshpass
    ```
* jq

  * ```bash
    brew install jq
    ```

* OVFTool 4.4

  * https://my.vmware.com/group/vmware/downloads/details?downloadGroup=OVFTOOL440&productId=967

# Instructions

## Run Terraform

### Configure variables

Most of the configuration options you require should be in the variables files.

The terraform will deploy a very simple environment with the following.

* Single VPC

* One subnet, one routing table and an IGW

* A management SG & Public ingres SG

* S3 bucket for storing OVAs to import

* IAM role for vmimport

This is the barebones you need to migrate your ESXi guest into AWS and have it working. Assuming it's a webserver.

### Terraform apply

To build the legacy environment run the following;

```bash
terraform init
terraform plan
terraform apply
```

## Create Secrets

### ESXi host password

The migrate script retreives your password from AWS Secrets Manager.

This is your ESXi password. I have chosen the root user but you don't have to. Set ESXI_USER in the migrate script `migrate_esxi_guest.sh`.

You will need to configure this as an AWS Secret.

Login to the AWS console, then create a "Other type of secret". Make sure it's in the region connfigured in your AWS config file.

If you don't have an encryption key click the Link "Add new key" to goto KMS. Or just keep selecting keys from the dropdown until something works...

Hint: Click on `Plantext` to switch to JSON

Set `Secret name` to `host/myesxihost.mydomain/user/root` <-- You must change the host name (myesxihost.mydomain) and user name (root) to your server/user, which also must match the migrate script. Unless you are using root of course.

Switch to Plain Text mode.

```json
{
  "password": "My Root Password (This isn't actually my root password) Or IS IT???"
}
```

Edit the `migrate_esxi_guest.sh` variables values like so it matches your secret value you jsut made.

```bash
ESXI_USER="root"
ESXI_HOST="myesxihost.mydomain"
SECRET_ID="host/$ESXI_HOST/user/$ESXI_USER" #Don't change this
SECRET_KEY="password"                       #Don't change this either
```

## Configure migrate script

The migrate script should now be partialy configured with account details above.

Next configure the following.

```bash
MIGRATE_GUEST="guestname"              # The guest you want to migrate
OVA_SAVE_DIR="."                       # The directory to save the OVA file in
MIGRATE_S3_BUCKET="myimportbucketname" # This has to match "disk_image_file_bucket" in variables.tf
```

## Run the script

You should be good to go. 

```bash
./migrate_esxi_guest.sh
```
The script will run and provide instructions to check progress on the migration.

Remember this will only create an AMI. You still have to launch it!

Good luck!


