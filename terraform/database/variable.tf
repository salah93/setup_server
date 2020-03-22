variable "do_token" {
    description             = "DigitalOcean token"
}

variable "db_name" {
  description               = "database name"
}

variable "size" {
  description               = "Size of Droplet"
}

variable "node_count" {
    description             = "Node count"
    default                 = "1"
}

variable "region" {
  description = "Digital Ocean Data Center"
  default     = "nyc1"
}
