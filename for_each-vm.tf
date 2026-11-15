data "yandex_compute_image" "ubuntu2" {
  family = "ubuntu-2004-lts"
}

variable "each_vm" {
  type = list(object({  
    vm_name = string, 
    cpu = number, 
    ram = number, 
    disk_volume = number 
  }))
  default = [
    {
      vm_name = "main"
      cpu = 2
      ram = 1
      disk_volume = 20
    },
    {
      vm_name = "replica"
      cpu = 2
      ram = 2
      disk_volume = 50
    }
  ]
}

locals {
  ssh-keys = file("/home/ubuntu/.ssh/yc.pub")
}

resource "yandex_compute_instance" "for_each" {
  for_each = {for i in var.each_vm: i.vm_name => i}
  name        = each.value.vm_name
  platform_id = "standard-v2"
  zone        = "ru-central1-d"
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.disk_volume
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu2.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.default-ru-central1-d.id
    nat       = true
    #security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${local.ssh-keys}"
  }
}
