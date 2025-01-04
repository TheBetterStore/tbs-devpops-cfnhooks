cd deploy-setup

stackName="tbs-devops-cfnhooks-deploysetup"
region="ap-southeast-2"

aws cloudformation deploy --template template-setup.yaml --stack-name $stackName \
--capabilities CAPABILITY_IAM CAPABILITY_NAMD_IAM --region $region
--profile thebetterstore-devopsaccount