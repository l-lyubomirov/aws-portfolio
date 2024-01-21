# Apache web service setup for the first case study.

This projects deploys an updated version, from the first case study, of an apache web service.
The architecture consists of the same resources from the first case study, with the difference that here i`ve tried to minimize the use of hard coded values.
In this case study I have included the use of modules and Terraform functions.
For this particular case study all policies are defined as template files.



## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.15.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_module-vpc"></a> [module-vpc](#module\_module-vpc) | ../modules/module-vpc | n/a |
| <a name="module_module-web-server"></a> [module-web-server](#module\_module-web-server) | ../modules/module-web-server | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.html-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_object.html-file](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb-config"></a> [alb-config](#input\_alb-config) | n/a | `map` | <pre>{<br>  "internal": false,<br>  "ip_adress_type": "ipv4",<br>  "load_balancer_type": "application"<br>}</pre> | no |
| <a name="input_alb-listener-config"></a> [alb-listener-config](#input\_alb-listener-config) | n/a | `map` | <pre>{<br>  "default_action_type": "forward",<br>  "port": 80,<br>  "protocol": "HTTP"<br>}</pre> | no |
| <a name="input_alb-tg-config"></a> [alb-tg-config](#input\_alb-tg-config) | n/a | `map` | <pre>{<br>  "port": 80,<br>  "protocol": "HTTP",<br>  "target_type": "instance"<br>}</pre> | no |
| <a name="input_ami-webserver"></a> [ami-webserver](#input\_ami-webserver) | n/a | `string` | `"ami-03a68febd9b9a5403"` | no |
| <a name="input_asg-config"></a> [asg-config](#input\_asg-config) | n/a | `map` | <pre>{<br>  "desired_capacity": 1,<br>  "health_check_grace_period": 300,<br>  "max_size": 2,<br>  "min_size": 1<br>}</pre> | no |
| <a name="input_default-route-cidr"></a> [default-route-cidr](#input\_default-route-cidr) | n/a | `string` | `"0.0.0.0/0"` | no |
| <a name="input_ec2-bastion-config"></a> [ec2-bastion-config](#input\_ec2-bastion-config) | n/a | `map` | <pre>{<br>  "ami": "ami-03a68febd9b9a5403",<br>  "instance_type": "t3.micro",<br>  "key_name": "ec2-ssh-key"<br>}</pre> | no |
| <a name="input_flow_logs_traffic_type"></a> [flow\_logs\_traffic\_type](#input\_flow\_logs\_traffic\_type) | n/a | `string` | `"ALL"` | no |
| <a name="input_health-check-alb"></a> [health-check-alb](#input\_health-check-alb) | n/a | `map` | <pre>{<br>  "health-check": {<br>    "enabled": true,<br>    "healthy_threshold": 5,<br>    "interval": 60,<br>    "matcher": "403,200",<br>    "path": "/",<br>    "port": "traffic-port",<br>    "protocol": "HTTP",<br>    "timeout": 5,<br>    "unhealthy_threshold": 10<br>  }<br>}</pre> | no |
| <a name="input_nacl-egress"></a> [nacl-egress](#input\_nacl-egress) | n/a | `map` | <pre>{<br>  "egress-all": {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "all",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>}</pre> | no |
| <a name="input_nacl-ingress"></a> [nacl-ingress](#input\_nacl-ingress) | n/a | `map` | <pre>{<br>  "ingress-all": {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "all",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>}</pre> | no |
| <a name="input_private-subnet-cidr"></a> [private-subnet-cidr](#input\_private-subnet-cidr) | n/a | `string` | `"10.0.5.0/24"` | no |
| <a name="input_project-name"></a> [project-name](#input\_project-name) | n/a | `string` | `"case2-lyubo"` | no |
| <a name="input_public-subnet-azs"></a> [public-subnet-azs](#input\_public-subnet-azs) | n/a | `list` | <pre>[<br>  "eu-south-1a",<br>  "eu-south-1b"<br>]</pre> | no |
| <a name="input_public-subnet-cidrs"></a> [public-subnet-cidrs](#input\_public-subnet-cidrs) | n/a | `list` | <pre>[<br>  "10.0.3.0/24",<br>  "10.0.4.0/24"<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-south-1"` | no |
| <a name="input_security-group-webserver-ingress"></a> [security-group-webserver-ingress](#input\_security-group-webserver-ingress) | n/a | `map` | <pre>{<br>  "Ingress HTTP": {<br>    "cidr_blocks": [<br>      "178.254.247.173/32"<br>    ],<br>    "description": "SSH",<br>    "from_port": "22",<br>    "protocol": "tcp",<br>    "to_port": "22"<br>  },<br>  "Ingress_SSH": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "HTTP",<br>    "from_port": "80",<br>    "protocol": "tcp",<br>    "to_port": "80"<br>  }<br>}</pre> | no |
| <a name="input_security-group1-egress"></a> [security-group1-egress](#input\_security-group1-egress) | n/a | `map` | <pre>{<br>  "egress": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>}</pre> | no |
| <a name="input_security-group1-ingress"></a> [security-group1-ingress](#input\_security-group1-ingress) | n/a | `map` | <pre>{<br>  "ingress_ssh": {<br>    "cidr_blocks": [<br>      "178.254.247.173/32"<br>    ],<br>    "description": "SSH",<br>    "from_port": "22",<br>    "protocol": "tcp",<br>    "to_port": "22"<br>  }<br>}</pre> | no |
| <a name="input_subnet-public-map"></a> [subnet-public-map](#input\_subnet-public-map) | n/a | `bool` | `true` | no |
| <a name="input_vpc-cidr"></a> [vpc-cidr](#input\_vpc-cidr) | n/a | `string` | `"10.0.0.0/16"` | no |
| <a name="input_webserver-instance-type"></a> [webserver-instance-type](#input\_webserver-instance-type) | n/a | `string` | `"t3.micro"` | no |

## Outputs

No outputs.
