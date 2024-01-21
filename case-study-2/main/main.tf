module "module-vpc" {
  source                           = "../modules/module-vpc"
  region                           = var.region
  project-name                     = var.project-name
  vpc-cidr                         = var.vpc-cidr
  public-subnet-cidrs              = var.public-subnet-cidrs
  public-subnet-azs                = var.public-subnet-azs
  private-subnet-cidr              = var.private-subnet-cidr
  security-group1-ingress          = var.security-group1-ingress
  security-group1-egress           = var.security-group1-egress
  security-group-webserver-ingress = var.security-group-webserver-ingress
  nacl-ingress                     = var.nacl-ingress
  nacl-egress                      = var.nacl-egress
  flow_logs_traffic_type           = var.flow_logs_traffic_type
  default-route-cidr               = var.default-route-cidr
  subnet-public-map                = var.subnet-public-map
  flowlog-policy-role              = templatefile("${path.module}/policies/assume-policy-flowlogs-role.json", {})
  flow-log-polices                 = templatefile("${path.module}/policies/flow-log-policies.json", {})
}