output info {
  value = "ssh ${var.gce_ssh_user}@${google_compute_address.ip_address.address}"
}

data "template_file" "success_output" {
  template = file("terraform_templates/output.tpl")

  vars = {
    username         = var.gce_ssh_user
    disk_size        = var.instance_disk_zie
    shared_disk_size = var.user_shared_disk_size
    zone             = var.zone
    ami_id           = var.ami_id
    bastion_host_ip  = google_compute_instance.bastion_instance.network_interface.0.access_config.0.nat_ip
  }
}

output "Success" {
  value = data.template_file.success_output.rendered
}
