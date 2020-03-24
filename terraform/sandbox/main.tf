provider "digitalocean" {
    token  = var.do_token
}

data "digitalocean_droplet_snapshot" "website" {
    name_regex = "sandbox-\\d*"
    region = var.region
    most_recent = true
}

resource "digitalocean_droplet" "sandbox" {
    name               = "sandbox"
    image              = data.digitalocean_droplet_snapshot.website.id
    region             = var.region
    size               = var.size
    ipv6               = true
    monitoring         = true
    ssh_keys           = var.ssh_keys
    private_networking = true
    tags               = [
        "sandbox"
    ]
}

resource "digitalocean_firewall" "sandbox" {
    depends_on = [digitalocean_droplet.sandbox]
    name = "ssh-only"

    tags = [
        "sandbox"
    ]

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    inbound_rule {
        protocol         = "tcp"
        port_range       = "514"
        source_tags      = ["website"]
    }

    inbound_rule {
        protocol         = "udp"
        port_range       = "514"
        source_tags      = ["website"]
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
