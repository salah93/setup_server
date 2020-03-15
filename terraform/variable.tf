variable "do_token" {
    description = "DigitalOcean Personal Access Token"
}

variable "ssh_keys" {
    description = "ssh key ids for digital ocean"
    type        = list
    default    = ["5407023", "11430846", "19610406"]
}

variable "private_key" {
  description = "private key"
  default     = "~/.ssh/id_rsa"
}

variable "image" {
  description = "Image to use"
  default     = "fedora-27-x64"
}

variable "size" {
  description = "Size of Droplet"
  default     = "512mb"
}

variable "name" {
  description = "Name of Droplet"
  default     = "sandbox"
}

variable "site-size" {
  description = "Size of Droplet"
  default     = "1gb"
}

variable "site-name" {
  description = "Name of Droplet"
  default     = "site"
}

variable "region" {
  description = "Digital Ocean Data Center"
  default     = "nyc1"
}
