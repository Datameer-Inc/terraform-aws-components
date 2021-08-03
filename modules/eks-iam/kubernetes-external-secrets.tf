# IAM permissions for the kubernetes-external-secrets operator, mainly to read credentials from Secrets Manager

module "kubernetes-external-secrets" {
  source                    = "./modules/service-account"

  service_account_name      = "kubernetes-external-secrets"
  service_account_namespace = "kubernetes-external-secrets"
  aws_iam_policy_document = join("", data.aws_iam_policy_document.kubernetes-external-secrets.*.json)

  cluster_context = local.cluster_context
  context         = module.this.context
}

data "aws_iam_policy_document" "kubernetes-external-secrets" {
  statement {
    sid = "ReadSecrets"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]

    effect = "Allow"
    resources = ["*"]

    # Limit to secrets tagged for argoCD
    condition {
      test     = "Null"
      values   = ["false"]
      variable = "secretsmanager:ResourceTag/argocd:credentials:type"
    }

  }

  statement {
    sid = "ListSecrets"

    actions = [
      "secretsmanager:ListSecrets"
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}
