variable "do_token" {
    description = "DigitalOcean Personal Access Token"
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

variable "data_center" { 
  description = "Digital Ocean Data Center"
  default     = "nyc1"
}