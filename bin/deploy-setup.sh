#!/bin/bash

cd ../deploy-setup

stackName="tbs-devops-cfnhooks-deploysetup"
region="ap-southeast-2"
targetOrgId="o-replaceme"

aws cloudformation deploy --template template-setup.yaml --stack-name $stackName \
--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --region $region \
--parameter-overrides OrgId=$targetOrgId \
--profile thebetterstore-tools