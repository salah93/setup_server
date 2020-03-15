provider "digitalocean" {
    token  = var.do_token
}

resource "digitalocean_droplet" "sandbox" {
    name               = "sandbox"
    image              = var.image
    region             = var.region
    size               = var.size
    ipv6               = true
    monitoring         = true
    ssh_keys           = var.ssh_keys
    private_networking = true
    tags = [
        "sandbox"
    ]
}

resource "digitalocean_firewall" "ssh" {
  name = "ssh-only"

  tags = ["sandbox"]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "sandbox-ip" {
    value = digitalocean_droplet.sandbox.ipv4_address
}
