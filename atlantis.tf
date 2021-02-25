module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "atlantis"
  cidr = "10.80.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.80.1.0/24", "10.80.2.0/24", "10.80.3.0/24"]
  public_subnets  = ["10.80.11.0/24", "10.80.12.0/24", "10.80.13.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}


module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"
  version = "~> 2.0"

  name = "atlantis"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  public_subnet_ids  = module.vpc.public_subnets
  route53_zone_name = "missionsa.net"

  atlantis_github_user       = data.aws_ssm_parameter.github_user.value
  atlantis_github_user_token = data.aws_ssm_parameter.github_token.value
  atlantis_repo_whitelist    = ["github.com/lalanza808/terraform-live-example"]

  allow_unauthenticated_access = true
  allow_github_webhooks        = true

  policies_arn = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    aws_iam_policy.atlantis-allow-s3-write.arn
  ]
}

resource "aws_iam_policy" "atlantis-allow-s3-write" {
  name = "atlantis-allow-s3-write"
  policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:*"]
          Effect   = "Allow"
          Resource = [
            "arn:aws:s3:::missionsa-atlantis-backend",
            "arn:aws:s3:::missionsa-atlantis-backend/*",
          ]
        },
        {
          Action = [
            "dynamodb:PutItem",
            "dynamodb:GetItem"
          ]
          Effect = "Allow"
          Resource = ["arn:aws:dynamodb:us-west-2:096194284558:table/missionsa-atlantis-backend"]
        }
      ]
    })
  }

data "aws_ssm_parameter" "github_user" {
  name = "github_user"
}

data "aws_ssm_parameter" "github_token" {
  name = "github_token"
}
