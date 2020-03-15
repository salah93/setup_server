variable "do_token" {
    description = "DigitalOcean Personal Access Token"
}

variable "ssh_keys" {
    description = "ssh key ids for digital ocean"
    type        = list
}

variable "private_key" {
  description = "private key"
}

variable "remote_user" {
  description = "remote user"
}

variable "image" {
  description = "Image to use"
}

variable "size" {
  description = "Size of Droplet"
}

variable "region" {
  description = "Digital Ocean Data Center"
  default     = "nyc1"
}
