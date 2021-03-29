data "terraform_remote_state" "account_map" {
  backend   = "s3"
  workspace = "${var.tfstate_role_environment_name}-${var.tfstate_role_stage_name}"

  config = {
    encrypt              = true
    bucket               = local.tfstate_bucket
    workspace_key_prefix = "account-map"
    key                  = "terraform.tfstate"
    dynamodb_table       = local.tfstate_dynamodb_table
    region               = var.region
    role_arn             = local.tfstate_access_role_arn
    acl                  = "bucket-owner-full-control"
  }
}

# data "terraform_remote_state" "account_map" {
#   backend   = "s3"
#   workspace = "${var.tfstate_role_environment_name}-${var.tfstate_role_stage_name}"
#   # workspace = "gbl-root"

#   config = {
#     encrypt              = true
#     bucket               = local.tfstate_bucket
#     # bucket               = "atmos-gbl-root-tfstate"
#     workspace_key_prefix = "account-map"
#     # key                  = "terraform.tfstate"
#     # dynamodb_table       = local.tfstate_dynamodb_table
#     dynamodb_table       = "atmos-gbl-root-tfstate-lock"
#     region               = var.region
#     # region               = "us-east-2"
#     role_arn             = local.tfstate_access_role_arn
#     # role_arn             = "arn:aws:iam::948006044704:role/nbo-master-admin"
#     acl                  = "bucket-owner-full-control"
#     key                  = "terraform.tfstate"
#   }
# }
