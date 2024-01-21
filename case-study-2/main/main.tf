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

module "module-web-server" {
  source                     = "../modules/module-web-server"
  ec2-bastion-config         = var.ec2-bastion-config
  health-check-alb           = var.health-check-alb
  webserver-instance-type    = var.webserver-instance-type
  asg-config                 = var.asg-config
  ami-webserver              = var.ami-webserver
  project-name               = var.project-name
  vpc-id                     = module.module-vpc.vpc-id
  public-subnet1-id          = module.module-vpc.public-subnet1-id
  public-subnet2-id          = module.module-vpc.public-subnet2-id
  security-group1-id         = module.module-vpc.security-group1-id
  webserver-securitygroup-id = module.module-vpc.webserver-securitygroup-id
  ngw-id                     = module.module-vpc.ngw-id
  private-subnet-id          = module.module-vpc.private-subnet-id
  depends_on                 = [module.module-vpc]
  alb-config                 = var.alb-config
  alb-listener-config        = var.alb-listener-config
  alb-tg-config              = var.alb-tg-config
  assume-policy-role         = templatefile("${path.module}/policies/assume-policy.json", {})
  s3-policy                  = templatefile("${path.module}/policies/s3getobj-policy.json", {})
  user-data                  = filebase64("${path.module}/scripts/apache-userdata.sh")
}