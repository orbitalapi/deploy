variable "region" {
   type    = string
   default = "eu-west-2"
}

variable "az" {
   type    = string
   default = "eu-west-2a"
}

variable "az2" {
   type    = string
   default = "eu-west-2b"
}

variable "system_name" {
   type = string
   default = "orbital"
}
variable "environment" {
   type        = string
   description = "Name of the environment that is used as part of the resource names and domains. "
   default = "prod"
}

variable "domain_name" {
   type = string
   description = "The subdomain where Orbital DNS will be configured for access"
}

variable "http_access_ip_range" {
   type = string
   description = "The IP range that Orbital will accept inbound HTTP(s) traffic from. Defaults to anywhere"
   default ="0.0.0.0/0"
}

variable "orbital_version" {
   type = string
   description = "The version / tag of Orbital"
   default = "latest"
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