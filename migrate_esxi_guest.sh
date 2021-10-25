#!/bin/bash

ESXI_USER="root"
ESXI_HOST="sexiboy.mgmt"
SECRET_KEY="password"
SECRET_ID="host/$ESXI_HOST/user/$ESXI_USER"
ESXI_PASSWORD=$( aws secretsmanager get-secret-value --secret-id $SECRET_ID | jq --raw-output '.SecretString' | jq -r ."$SECRET_KEY")
MIGRATE_GUEST="djmaddox.co.uk"
OVA_SAVE_DIR="."
MIGRATE_S3_BUCKET="sarrionandia-legacy-vm-import"

# Get VMID from MIGRATE_GUEST
VMID=$(sshpass -p "$ESXI_PASSWORD" ssh "$ESXI_USER"@"$ESXI_HOST" sh" << EOF
vim-cmd vmsvc/getallvms | grep \"$MIGRATE_GUEST\\s\"  | cut -d \" \" -f1
EOF")


# Check if VMID is a value then shut it down
if [ -n "$VMID" ]; then
{
# Power off Machine
sshpass -p "$ESXI_PASSWORD" ssh "$ESXI_USER"@"$ESXI_HOST" sh" << EOF
if !(vim-cmd vmsvc/power.getstate $VMID | grep 'Powered off');
then
  echo 'Shutting Down: $MIGRATE_GUEST'
  vim-cmd vmsvc/power.shutdown $VMID
  while !(vim-cmd vmsvc/power.getstate $VMID | grep 'Powered off');
  do
    sleep 1
    echo Powering off...
  done
  echo 'Powered off: $MIGRATE_GUEST'
fi
EOF"
}
else echo VMID not found && exit
fi


# Export VM
ovftool \
vi://"${ESXI_USER}":"${ESXI_PASSWORD}"@"${ESXI_HOST}"/"${MIGRATE_GUEST}" \
"${OVA_SAVE_DIR}"/"${MIGRATE_GUEST}".ova


# Power ON machine
sshpass -p "$ESXI_PASSWORD" ssh "$ESXI_USER"@"$ESXI_HOST" sh" << EOF
  echo 'Powering On: $MIGRATE_GUEST'
  vim-cmd vmsvc/power.on $VMID
EOF"


# Copy VMA to S3 Bucket

aws s3 cp "${OVA_SAVE_DIR}"/"${MIGRATE_GUEST}".ova s3://"${MIGRATE_S3_BUCKET}"

# Import VMA to AMI

IMPORT_TASK_ID=$(aws ec2 import-image --disk-containers Format=OVA,Url=S3://"${MIGRATE_S3_BUCKET}"/"${MIGRATE_GUEST}".ova | jq --raw-output '.ImportTaskId')

echo "To check progress paste this in: aws ec2 describe-import-image-tasks --import-task-ids ${IMPORT_TASK_ID}|jq"