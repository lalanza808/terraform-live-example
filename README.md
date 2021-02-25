# terraform-live-example
Example of a Terraform repo for managing infrastructure


## Atlantis Setup

1. Setup terraform state backend (S3 + DynamoDB)

```
aws cloudformation deploy \
    --stack-name missionsa-atlantis-backend \
    --template-file ./terraform-backend-cft.yaml
```

2. Setup secrets

```
aws ssm put-parameter \
    --name "github_user" \
    --type "String" \
    --value "myusername"

aws ssm put-parameter \
    --name "github_token" \
    --type "String" \
    --value "myusertoken"
```

3. Terraform init and apply

```
terraform init
terraform apply
```
