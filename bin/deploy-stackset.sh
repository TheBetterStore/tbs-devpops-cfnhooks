#!/bin/bash

stackName="tbs-devops-cfnhooks-stackset"
region="ap-southeast-2"
devopsAccountId="1234" # To replace
targetOrgUnitIds="234,34534" # To replace
deployBucket="lambdacfnhooks-${devopsAccountId}-deploybucket"
currentTime=$(date +"%Y%m%d%H%M%S")

cd ../tbs-devops-cfnhooks

# First we build our SAM solution
aws cloudformation package --template-file template.yaml \
--s3-bucket $deployBucket --s3-prefix $stackName --region $region \
--output-template-file generated-template.yaml \
--profile thebetterstore-devopsaccount

# Next export our generated template to S3
aws s3 cp ./generated-template.yaml s3://$deployBucket/generated-template.yaml \
--profile thebetterstore-tools


# Next deploy the stackset, defined in IaC (Cfn) to our devops account, which will then manage deployment of the hooks to accounts
# within specified target OU's. NB use lastupdatedtime tag to ensure deployment/that changes are detected
cd ../deploy-setup
aws cloudformation deploy --template template-stackset.yaml --stack-name $stackName \
--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --region $region \
--parameter-overrides TemplateUrl="https://$deployBucket.s3.ap-southeast-2.amazonaws.com/generated-template.yaml" \
TargetOrgUnitIds=${targetOrgUnitIds} \
--tags lastupdatedtime="$currentTime" \
--profile thebetterstore-tools