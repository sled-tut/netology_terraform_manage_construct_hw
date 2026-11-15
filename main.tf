resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_network" "default" {
  name = var.vpc_name_d
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_vpc_subnet" "default-ru-central1-d" {
  name           = "subnet"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.130.0.0/24"]
}
