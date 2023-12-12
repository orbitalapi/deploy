variable "system_name" {
   type        = string
   description = "System name."
}

variable "environment" {
   type        = string
   description = "Name of the environment that is used as part of the resource names and domains. "
}

variable "region" {
   type        = string
   description = "The AWS region like eu-west-1."
}

variable "external_connectivity_security_group_id" {
   type        = string
   description = "Security group id to be used for the load balancer."
}

variable "vpc_id" {
   type        = string
   description = "The VPC id."
}

variable "subnets" {
   type        = set(string)
   description = "The VPC subnets."
}

variable "subnet_1_id" {
   type        = string
   description = "A subnet's id. Needs to match the subnet_1_arn."
}

variable "subnet_1_arn" {
   type        = string
   description = "A subnet's ARN. Needs to match the subnet_1_id."
}

variable "subnet_2_id" {
   type        = string
   description = "The second subnet's id."
}

variable "cert_arn" {
   type        = string
   description = "The load balancer certificate ARN."
}
variable "route53_zone_id" {
   type        = string
   description = "The Route53 zone id."
}

variable "domain_name" {
   type        = string
   description = "The sub domain name being used for this environment"
}

variable "database_host" {
   type        = string
   description = "The RDS Postgres hostname."
}

variable "database_port" {
   type = string
   description = "The RDS Postgres port"
}

variable "database_username" {
   type        = string
   description = "The RDS Postgres username."
}

variable "database_password" {
   type        = string
   description = "The RDS Postgres password."
}

variable "orbital_workspace_git_url" {
   type = string
   description = "The git url (including a PAT if required) for reading a workspace config from git"
}

variable "orbital_workspace_git_branch" {
   type = string
   description = "The name of the git branch to read the workspace.conf file from"
   default = "main"
}

variable "orbital_workspace_git_path" {
   type = string
   description = "The path within the git repository to the workspace.conf file"
   default = "workspace.conf"
}


variable "orbital_version" {
   type = string
   description = "The version / tag of Orbital"
}

// Application configuration
variable "orbital_persist_results" {
   type = bool
   description = "Configures if Orbital persists results of queries"
   default = false
}

variable "orbital_persist_remote_call_responses" {
   type = bool
   description = "Configures if Orbital persists results of remote calls"
   default = false
}