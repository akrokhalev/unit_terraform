terraform {
  required_providers {
    yandex = {
        source = "yandex-cloud/yandex"
        version = "0.90.0"
    }
  }
}

locals {
  folder_id = "b1gppsosmkmr6sm6ream"
  cloud_id = "b1g3p7mlsl60dog8mj4t"
}

provider "yandex" {
  cloud_id = local.cloud_id
  folder_id = local.folder_id
  service_account_key_file = "/home/key/authorized_key.json"

  
}