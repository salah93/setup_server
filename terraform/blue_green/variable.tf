variable "do_token" {
    description = "DigitalOcean Personal Access Token"
}

variable "size" {
  description = "Size of Droplet"
}

variable "region" {
  description = "Digital Ocean Data Center"
  default     = "nyc1"
}

variable "node_count" {
    description = "Node count"
    default     = "1"
}

variable "ssh_keys" {
    description = "ssh key ids for digital ocean"
    type        = list
}

variable "color" {
  description = "blue/green"
}

variable "remote_user" {
  description = "remote user"
}

variable "release" {
  description = "release version"
}
