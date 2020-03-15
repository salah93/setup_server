provider "digitalocean" {
    token  = var.do_token
}

resource "digitalocean_droplet" "sandbox" {
    name               = "sandbox-01"
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

    connection {
        type        = "ssh"
        private_key = file(var.private_key)
        user        = var.remote_user
        host        = self.ipv4_address
        timeout     = "3m"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo rm -rf .ansible"
        ]
    }

    provisioner "local-exec" {
        command = <<EOT
            ansible-playbook -u ${var.remote_user} --private-key=${var.private_key} -i "${digitalocean_droplet.sandbox.ipv4_address}," --ssh-extra-args="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" --tags=user $PLAYBOOK
            EOT
        working_dir = ".."
        environment = {
            PLAYBOOK = "user-playbook.yml"
        }
    }

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
