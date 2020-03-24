provider "digitalocean" {
    token  = var.do_token
}

data "digitalocean_droplet_snapshot" "website" {
    name_regex  = "sandbox-\\d*"
    region      = var.region
    most_recent = true
}

resource "digitalocean_droplet" "website" {
    count              = var.node_count
    name               = format("website-%s-%.2d", var.release, count.index)
    image              = data.digitalocean_droplet_snapshot.website.id
    region             = var.region
    size               = var.size
    ipv6               = true
    monitoring         = true
    ssh_keys           = var.ssh_keys
    private_networking = true
    tags = [
        "website",
        replace(var.release, ".", "-"),
        var.color
    ]

    connection {
        type        = "ssh"
        user        = var.remote_user
        host        = self.ipv4_address
        timeout     = "3m"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo rm -rf .ansible"
        ]
    }
}

output "ips" {
    value = digitalocean_droplet.website[*].ipv4_address
}
