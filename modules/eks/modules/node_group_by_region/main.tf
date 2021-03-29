locals {
  az_set  = toset(var.availability_zones)
  az_list = tolist(local.az_set)
}


module "node_group" {
  for_each = module.this.enabled ? local.az_set : []

  source            = "../node_group_by_az"
  availability_zone = each.value

  node_group_size = {
    # TODO: seems like a wrong expression
    # https://www.terraform.io/docs/language/functions/floor.html
    # when desired_size = 1
    # floor((1 + 0) / 3) = 0.333; floor(0.333) = 0
    # floor((1 + 1) / 3) = 0.677; floor(0.677) = 0
    # floor((1 + 2) / 3) = 1; floor(1) = 1
    # when desired_size = 3
    # floor((3 + 0) / 3) = 1; floor(1) = 1
    # floor((3 + 1) / 3) = 1.333; floor(0.677) = 1
    # floor((3 + 2) / 3) = 1.677; floor(1) = 1
    desired_size = floor((var.node_group_size.desired_size + index(local.az_list, each.value)) / length(local.az_list))
    min_size     = floor((var.node_group_size.min_size + index(local.az_list, each.value)) / length(local.az_list))
    max_size     = floor((var.node_group_size.max_size + index(local.az_list, each.value)) / length(local.az_list))
  }

  cluster_context = var.cluster_context
  context         = module.this.context
}

output "debug" {
  value = var.node_group_size.desired_size
}
output "debug1" {
  value = local.az_list
}
output "debug2" {
  value = local.az_set
}
