# Web-server Module
In this module we are deploying a bastion host and apache web server in an auto-scaling group, that sits behind application load balancer.

Important thing to mention here is that this module is dependent on the VPC Module that is part of this repository.

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
| [aws_autoscaling_group.autoscaling-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.profile-ec2-iam](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_instance_profile.profile-ec2-iam-bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.s3-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.iam-role-bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.iam-role-ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.s3getobject-role-policy-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm-role-policy-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm-role-policy-attach-bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.bastion-host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_launch_template.launch-template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.alb-listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.alb-target-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb-config"></a> [alb-config](#input\_alb-config) | The configuration of the application load balancer | <pre>object({<br>    internal           = bool<br>    ip_adress_type     = string<br>    load_balancer_type = string<br>  })</pre> | n/a | yes |
| <a name="input_alb-listener-config"></a> [alb-listener-config](#input\_alb-listener-config) | The configuration of the alb listener | <pre>object({<br>    port                = number<br>    protocol            = string<br>    default_action_type = string<br>  })</pre> | n/a | yes |
| <a name="input_alb-tg-config"></a> [alb-tg-config](#input\_alb-tg-config) | The configuration of the target group for the application load balancer | <pre>object({<br>    port        = number<br>    protocol    = string<br>    target_type = string<br>  })</pre> | n/a | yes |
| <a name="input_ami-webserver"></a> [ami-webserver](#input\_ami-webserver) | The AMI of the web server | `string` | n/a | yes |
| <a name="input_asg-config"></a> [asg-config](#input\_asg-config) | The configuration of the autoscaling group(minimal and maximal size, desired capacity and health check period) | <pre>object({<br>    min_size                  = number<br>    max_size                  = number<br>    desired_capacity          = number<br>    health_check_grace_period = number<br>  })</pre> | n/a | yes |
| <a name="input_assume-policy-role"></a> [assume-policy-role](#input\_assume-policy-role) | This variable is used to refer the json file for the ec2 role | `string` | n/a | yes |
| <a name="input_ec2-bastion-config"></a> [ec2-bastion-config](#input\_ec2-bastion-config) | The bastion host configuration of ami, isntance type and key name. | <pre>object({<br>    ami           = string<br>    instance_type = string<br>    key_name      = string<br>  })</pre> | n/a | yes |
| <a name="input_health-check-alb"></a> [health-check-alb](#input\_health-check-alb) | The rules for the health check of the alb target group | <pre>object({<br>    health-check = object({<br>      enabled             = bool<br>      interval            = number<br>      path                = string<br>      protocol            = string<br>      timeout             = number<br>      healthy_threshold   = number<br>      unhealthy_threshold = number<br>      matcher             = string<br>      port                = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_ngw-id"></a> [ngw-id](#input\_ngw-id) | This variable is used to determine the ID of the nat-gateway from the vpc to the web-server module | `string` | n/a | yes |
| <a name="input_private-subnet-id"></a> [private-subnet-id](#input\_private-subnet-id) | This variable is used to determine the ID of a private subnet from the vpc to the web-server module | `string` | n/a | yes |
| <a name="input_project-name"></a> [project-name](#input\_project-name) | The name of the project. | `string` | n/a | yes |
| <a name="input_public-subnet1-id"></a> [public-subnet1-id](#input\_public-subnet1-id) | This variable is used to determine public subnet ID from the vpc to the web-server module | `string` | n/a | yes |
| <a name="input_public-subnet2-id"></a> [public-subnet2-id](#input\_public-subnet2-id) | This variable is used to determine public subnet ID from the vpc to the web-server module | `string` | n/a | yes |
| <a name="input_s3-policy"></a> [s3-policy](#input\_s3-policy) | This variable is used to refer the json file for the policies for the S3 role | `string` | n/a | yes |
| <a name="input_security-group1-id"></a> [security-group1-id](#input\_security-group1-id) | This variable is used to determine the ID of a security group from the vpc to the web-server module | `string` | n/a | yes |
| <a name="input_user-data"></a> [user-data](#input\_user-data) | The user data for the web-server | `string` | n/a | yes |
| <a name="input_vpc-id"></a> [vpc-id](#input\_vpc-id) | The ID of the VPC | `string` | n/a | yes |
| <a name="input_webserver-instance-type"></a> [webserver-instance-type](#input\_webserver-instance-type) | The instance type of the web server | `string` | n/a | yes |
| <a name="input_webserver-securitygroup-id"></a> [webserver-securitygroup-id](#input\_webserver-securitygroup-id) | This variable is used to determine the ID of a security group from the vpc to the web-server module | `string` | n/a | yes |

