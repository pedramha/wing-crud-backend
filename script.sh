#!/bin/bash

if command -v uuidgen > /dev/null; then
    unique=$(uuidgen | tr '[:upper:]' '[:lower:]')
else
    unique="$(date +%s)-$RANDOM"
fi
bucket_name="state-bucket-$unique"
table_name="lock-table-$unique"
echo "Unique bucket name: $bucket_name"
echo "Unique table name: $table_name"

region="${AWS_DEFAULT_REGION:-$(aws configure get region)}"

aws s3api create-bucket --bucket $bucket_name --region $region --create-bucket-configuration LocationConstraint=$region
aws s3api put-bucket-versioning --bucket $bucket_name --versioning-configuration Status=Enabled
# dynamodb for creating lock file, to prevent users simultaneously modifying the state file
aws dynamodb create-table --table-name $table_name --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST
echo TF_BACKEND_BUCKET=$bucket_name > .env
echo TF_BACKEND_TABLE=$table_name >> .env
echo TF_BACKEND_REGION=$region >> .env