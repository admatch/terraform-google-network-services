# Terraform Google Networking Services Module

## Overview

This Terraform module facilitates the creation of networking services on Google Cloud Platform. It includes the setup of DNS, certificate, load balancer and support configuration for a storage bucket backend or a serverless function.

## Features

* Create a dns managed zone, and assign a permanent ip address 
* Create and register a managed certificate for your domain
* Setup load balancer, proxy, etc. for a a storage bucket backend or a serverless function

Note: the DNS record must be updated externally with the IP address returned by the module

## Usage

```
module "network_services" {
  source                   = "github.com/admatch/terraform-google-network-services"
  cloud_function_name      = module.my_function.function_name
  dns_name                 = var.environment == "production" ?  "sub.example.com" : "${var.environment}.sub.example.com."
  environment              = var.environment
  environment_code         = substr(var.environment, 0, 1)
  project                  = local.env_project_id
  project_name             = local.project_suffix
  region                   = var.region
}
```