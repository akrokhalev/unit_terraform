output "webserver_ip" {
  value = yandex_compute_instance.vm-test1.network_interface.0.nat_ip_address
}
