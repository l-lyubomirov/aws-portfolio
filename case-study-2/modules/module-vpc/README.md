# VPC Module
In this module we are deploying the main network resources for our web server. (VPC, IGW, NatGW, subnets, security groups, route tables and flow logs.)

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cw-log-gr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eip.ngw-eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.flow-logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.role-flowlogs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.policy-flowlogs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.nacl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_route_table.private-route-table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public-route-table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.pr-subnet-route-table-association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.pu-subnet-route-table-association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.security-group1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.webserver-securitygroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private-subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.pu-subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default-route-cidr"></a> [default-route-cidr](#input\_default-route-cidr) | The default route for the rooting tabel | `string` | n/a | yes |
| <a name="input_flow-log-polices"></a> [flow-log-polices](#input\_flow-log-polices) | This variable is used to refer the json file for the policies for the flow logs role | `string` | n/a | yes |
| <a name="input_flow_logs_traffic_type"></a> [flow\_logs\_traffic\_type](#input\_flow\_logs\_traffic\_type) | The type of traffic collected by the flow logs | `string` | n/a | yes |
| <a name="input_flowlog-policy-role"></a> [flowlog-policy-role](#input\_flowlog-policy-role) | This variable is used to refer the json file for the flow logs role | `string` | n/a | yes |
| <a name="input_nacl-egress"></a> [nacl-egress](#input\_nacl-egress) | The egress rules for the nacl | <pre>object({<br>    egress-all = object({<br>      protocol   = string<br>      rule_no    = number<br>      action     = string<br>      cidr_block = string<br>      from_port  = number<br>      to_port    = number<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_nacl-ingress"></a> [nacl-ingress](#input\_nacl-ingress) | The ingress rules for the nacl | <pre>object({<br>    ingress-all = object({<br>      protocol   = string<br>      rule_no    = number<br>      action     = string<br>      cidr_block = string<br>      from_port  = number<br>      to_port    = number<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_private-subnet-cidr"></a> [private-subnet-cidr](#input\_private-subnet-cidr) | Private subnet cidr block | `string` | n/a | yes |
| <a name="input_project-name"></a> [project-name](#input\_project-name) | The name of the project. | `string` | n/a | yes |
| <a name="input_public-subnet-azs"></a> [public-subnet-azs](#input\_public-subnet-azs) | Public Subnet CIDR values | `list(string)` | n/a | yes |
| <a name="input_public-subnet-cidrs"></a> [public-subnet-cidrs](#input\_public-subnet-cidrs) | Public Subnet CIDR values | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region for the project | `string` | n/a | yes |
| <a name="input_security-group-webserver-ingress"></a> [security-group-webserver-ingress](#input\_security-group-webserver-ingress) | The ingress rules for the web server security group | <pre>object({<br>    Ingress_SSH = object({<br>      description = string<br>      from_port   = string<br>      to_port     = string<br>      protocol    = string<br>      cidr_blocks = list(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_security-group1-egress"></a> [security-group1-egress](#input\_security-group1-egress) | The egress rules for the first security group | <pre>object({<br>    egress = object({<br>      from_port   = number<br>      to_port     = number<br>      protocol    = string<br>      cidr_blocks = list(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_security-group1-ingress"></a> [security-group1-ingress](#input\_security-group1-ingress) | The ingress rules for the first security group | <pre>object({<br>    ingress_ssh = object({<br>      description = string<br>      from_port   = string<br>      to_port     = string<br>      protocol    = string<br>      cidr_blocks = list(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_subnet-public-map"></a> [subnet-public-map](#input\_subnet-public-map) | The map of the public subnets | `bool` | n/a | yes |
| <a name="input_vpc-cidr"></a> [vpc-cidr](#input\_vpc-cidr) | VPC cidr block | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ngw-id"></a> [ngw-id](#output\_ngw-id) | n/a |
| <a name="output_private-subnet-id"></a> [private-subnet-id](#output\_private-subnet-id) | n/a |
| <a name="output_public-subnet1-id"></a> [public-subnet1-id](#output\_public-subnet1-id) | n/a |
| <a name="output_public-subnet2-id"></a> [public-subnet2-id](#output\_public-subnet2-id) | n/a |
| <a name="output_security-group1-id"></a> [security-group1-id](#output\_security-group1-id) | n/a |
| <a name="output_vpc-id"></a> [vpc-id](#output\_vpc-id) | n/a |
| <a name="output_webserver-securitygroup-id"></a> [webserver-securitygroup-id](#output\_webserver-securitygroup-id) | n/a |
