provider "google" {
  credentials = file(var.google_credentials) #GOOGLE_CREDENTIALS to the path of a file containing the credential JSON
  project     = var.google_project_id
  zone        = var.zone
}

resource "google_compute_firewall" "default" {
  count   = length(var.firewall_rules)
  name    = lookup(var.firewall_rules[count.index], "name")
  network = google_compute_instance.bastion_instance.network_interface[0].network

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = [lookup(var.firewall_rules[count.index], "port")]
  }

  source_ranges = [lookup(var.firewall_rules[count.index], "cidr")]
  source_tags   = ["bastion-firewall"]
}

resource "google_compute_address" "ip_address" {
  name = "${var.deployment_name}-elastick-ip"
}

resource "google_compute_disk" "bastion_user_data_disk" {
  name = "${var.deployment_name}-shared-disk"
  type = "pd-ssd"
  size = var.user_shared_disk_size

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_instance" "bastion_instance" {
  name         = "${var.deployment_name}-${replace(var.google_domain_name, ".", "-")}"
  machine_type = var.machine_type

  tags = ["bastion-firewall"]

  allow_stopping_for_update = var.allow_stopping_for_update

  boot_disk {
    initialize_params {
      size  = var.instance_disk_zie
      image = var.ami_id
    }
  }

  attached_disk {
    source      = google_compute_disk.bastion_user_data_disk.self_link
    device_name = google_compute_disk.bastion_user_data_disk.name
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.ip_address.address
    }
  }

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  metadata_startup_script = <<EOF
  ## Clone and make sure common scripts stored in bastion host 
  echo 'export GIT_TOKEN="${var.git_common_token}"' >> /root/.zshrc 
  git clone https://${var.git_common_token}@github.com/fuchicorp/common_scripts.git /common_scripts

  ## Adding crontab to make sure instance always clean
  echo '@hourly source /root/.zshrc && cd /common_scripts/bastion-scripts/ && python3 sync-users.py --refresh' > /sync-crontab 
  echo '0 2 * * */2,4,6 /usr/bin/find /fuchicorp/home -iname ".terraform" -exec rm -rf {} \; 2>/dev/null' >> /sync-crontab
  echo '0 2 * * */2,4,6 /usr/bin/find /fuchicorp/home -iname ".vscode-server" -exec rm -rf {} \; 2>/dev/null' >> /sync-crontab
  echo '@daily sudo python3 /common_scripts/bastion-scripts/backup-scripts/backup-all.py' >> /sync-crontab
  echo '0 12 * * 0 yes | docker system prune -a &> /dev/null' >> /sync-crontab

  ## Adding crontab to git pull scripts from common_scripts repo
  echo '@hourly cd /common_scripts/  && git pull && chmod +x -R /common_scripts/bastion-scripts/bin/' >> /sync-crontab 

  ## Making sure ext4 is set to shared disk
  if ! echo "$(blkid /dev/sdb)" | grep  'ext4'; then
    mkfs.ext4 /dev/sdb -F 
  fi

  ## if fuchicorp folder in linux is not exist it will be created
  if [ ! -d '/fuchicorp' ]; then
    mkdir '/fuchicorp/home' -p  && chmod 755 '/fuchicorp/home' 
  fi
  
  mount -o discard,defaults '/dev/sdb' '/fuchicorp'

  ## Onboarding when instance restared or on first start
  source /root/.zshrc && cd /common_scripts/bastion-scripts/ && python3 sync-users.py --refresh
  crontab /sync-crontab
  EOF
}

resource "null_resource" "check_packages" {
  depends_on = [google_compute_instance.bastion_instance]

  provisioner "remote-exec" {
    script     = "scripts/check-required-packages.sh"
    on_failure = fail

    connection {
      host        = google_compute_instance.bastion_instance.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = var.gce_ssh_user
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
