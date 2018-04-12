provider "digitalocean" {
    token  = "${var.do_token}"
}

resource "digitalocean_droplet" "sandbox" {
    # Obtain ssh-key ids via api https://developers.digitalocean.com/documentation/v2/#list-all-keys
    # Alternatively, use ssh fingerprint `ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}'`
    ssh_keys           = ["5407023", "11430846", "19610406"]
    image              = "${var.image}"
    region             = "${var.data_center}"
    size               = "${var.size}"
    name               = "${var.name}"

    connection {
        type        = "ssh"
        private_key = "${file(var.private_key)}"
        user        = "root"
        timeout     = "3m"
    }

    provisioner "remote-exec" {
        inline = ["dnf -y update",
                  "dnf install -y python2-dnf",
                 ]
    }

    provisioner "local-exec" {
        command = <<EOT
            echo [sandboxes] > $INVENTORY
            echo ${digitalocean_droplet.sandbox.ipv4_address} >> $INVENTORY
            ansible-playbook $PLAYBOOK -i $INVENTORY
            EOT

        working_dir = ".."
        environment {
            INVENTORY = "/tmp/inventory"
            PLAYBOOK = "playbook.yml"
        }
    }

    provisioner "local-exec" {
        command = "echo backup data"
        when    = "destroy"
    }
}

output "ip" {
    value = "${digitalocean_droplet.sandbox.ipv4_address}"
}