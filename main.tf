terraform {
  required_providers {
    yandex = {
        source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}


provider "yandex" {
  cloud_id = var.cloud_id_var
  folder_id = var.folder_id_var
  service_account_key_file = var.service_account_key_file_var
  zone = "ru-central1-a"

  
}

#data "yandex_compute_image" "ubuntu_image" {
#  family = "ubuntu-2004-lts"
#}

resource "yandex_vpc_subnet" "subnet_terraform" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network_terraform.id
  v4_cidr_blocks = ["192.168.15.0/24"]
}


resource "yandex_compute_instance" "vm-test1" {
  name = "test1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
    #      image_id = data.yandex_compute_image.ubuntu_image.id
    image_id = "fd8go38kje4f6v3g2k4q"  

    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_terraform.id
    security_group_ids = [yandex_vpc_security_group.my_webserver.id]
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

provisioner "remote-exec" {
    inline = [
      "sudo apt install -y curl | apt install mc"
    ]
    connection {
      host        = self.network_interface.0.nat_ip_address
      type        = "ssh"
      user        = "akrokhalev"
      private_key = file(var.private_key_file_path)
    }
  }

provisioner "local-exec" {
      when       = create
      on_failure = continue
      command    = "echo ${self.network_interface.0.nat_ip_address} >> hosts |  ansible-playbook -u akrokhalev -i '${self.network_interface.0.nat_ip_address},' --private-key ${var.private_key_file_path} create_nginx.yml"
  }
}

resource "yandex_vpc_network" "network_terraform" {
  name = "network_terraform"
}


resource "yandex_vpc_security_group" "my_webserver" {
  name        = "WebServer security group"
  description = "my_security_group"
  network_id  = yandex_vpc_network.network_terraform.id

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = -1
  }
}
