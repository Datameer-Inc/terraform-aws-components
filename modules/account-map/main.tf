# This is an information only project, that simply populates Terraform state
# with information other modules need.

# data "aws_organizations_organization" "organization" {}

locals {
  # full_account_map = {
  #   for acct in data.aws_organizations_organization.organization.accounts : acct.name => acct.id
  # }

  # TODO: to process based on the data.aws_organizations_organization.organization
  # eks_accounts     = data.terraform_remote_state.accounts.outputs.eks_accounts
  # non_eks_accounts = data.terraform_remote_state.accounts.outputs.non_eks_accounts

  # workaround
  full_account_map = var.full_account_map
  eks_accounts = var.eks_accounts
  non_eks_accounts = var.non_eks_accounts

  all_accounts     = concat(local.eks_accounts, local.non_eks_accounts)

  terraform_roles = {
    for name, id in local.full_account_map : name => format(var.iam_role_arn_template,
      id,
      module.this.namespace,
      module.this.environment,
      name,
      (contains([
        var.root_account_stage_name,
        var.identity_account_stage_name
      ], name) ? "admin" : "terraform")
    )
  }
}

# workaround: temporarily disable state export and provide input through variables
variable "full_account_map" {
  type = any
}

variable "eks_accounts" {
  type = any
}

variable "non_eks_accounts" {
  type = any
}
