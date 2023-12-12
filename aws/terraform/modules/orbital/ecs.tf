resource "aws_ecs_cluster" "cluster" {
  name = var.system_name
}

resource "aws_security_group" "ecs_service" {
  vpc_id      = var.vpc_id
  name_prefix = var.system_name
  description = "Fargate service security group for ${var.environment}"

  revoke_rules_on_delete = true

  ingress {
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    security_groups = [var.external_connectivity_security_group_id, aws_security_group.alb.id]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "orbital" {
  source                    = "./modules/service"
  service_name              = var.system_name
  environment               = var.environment
  region                    = var.region
  vpc_id                    = var.vpc_id
  subnets                   = var.subnets
  image                     = "orbitalhq/orbital:${var.orbital_version}"
  task_definition_cpu       = 2048
  task_definition_memory    = 4096
  port                      = 9022
  protocol                  = "HTTP"
  execution_role_arn        = aws_iam_role.execution.arn
  task_role_arn             = aws_iam_role.task.arn
  cluster_id                = aws_ecs_cluster.cluster.id
  cloudwatch_log_group_name = aws_cloudwatch_log_group.main.name
  security_groups           = [aws_security_group.ecs_service.id, var.external_connectivity_security_group_id]
  health_check              = {
    path = "/api/actuator/health"
    port = 9022
  }
  environment_variables = {
    VYNE_DB_HOST                                 = var.database_host
    VYNE_DB_PORT                                 = var.database_port
    VYNE_DB_USERNAME                             = var.database_username
    VYNE_DB_PASSWORD                             = var.database_password
    VYNE_ANALYTICS_PERSIST_REMOTE_CALL_RESPONSES = tostring(var.orbital_persist_remote_call_responses)
    VYNE_ANALYTICS_PERSIST_RESULTS               = tostring(var.orbital_persist_results)
    VYNE_WORKSPACE_GIT_URL                       = var.orbital_workspace_git_url
    VYNE_WORKSPACE_GIT_BRANCH                    = var.orbital_workspace_git_branch
    VYNE_WORKSPACE_GIT_PATH                      = var.orbital_workspace_git_path
  }
}
