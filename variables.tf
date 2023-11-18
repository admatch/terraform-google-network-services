
variable "cloud_function_name" {
  type          = string
  description   = "The cloud function name of the network services will be used for a backend function"
  nullable      = true
}

variable "dns_name" {
  type          = string
  description   = "The dns name for the certificate without the trailing dot (.)"
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
