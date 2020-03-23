variable "do_token" {
    description       = "DigitalOcean Personal Access Token"
}

variable "region" {
  description         = "Digital Ocean Data Center"
  default             = "nyc1"
}

variable "access" {
  description         = "ip address of machine you want to run ansible scripts"
}

variable "domain" {
  description         = "domain of load balancer"
}
