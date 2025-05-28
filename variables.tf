variable "bucket_name" {
  type          = string
  description   = "The bucket name that network services will use as backend"
  nullable      = true
  default       = null
}


variable "cloud_function_name" {
  type          = string
  description   = "The cloud function name that network services will use as backend"
  nullable      = true
  default       = null
}

variable "dns_name" {
  type          = string
  description   = "The dns name for the zone without the trailing dot (.)"
  nullable      = false
}

variable "environment" {
  type          = string
  description   = "The name of the environment e.g. prod"
  nullable      = false
}

variable "environment_code" {
  type          = string
  description   = "The one letter code for the environment e.g. p"
  nullable      = false
}

variable "project" {
  type          = string
  description   = "The project id where the network services will be created e.g. prj-web-app-xyza"
  nullable      = false
}

variable "project_name" {
  type          = string
  description   = "The project litteral name e.g. my-web-app"
  nullable      = false
}

variable "region" {
  type          = string
  description   = "The region where the network services will be created e.g. us-west1"
  nullable      = false
}

variable "hostnames" {
  type          = list(string)
  description   = "The hostnames for the certificate"
  nullable      = true
}

variable "url_rewrite_rules" {
  description = "List of rewrite rules, each with list of paths and a path prefix rewrite string"
  type = list(object({
    paths               = list(string)
    path_prefix_rewrite = string
  }))
  default  = []
  nullable = true
}
