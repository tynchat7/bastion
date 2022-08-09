#!/bin/bash 
sudo useradd --no-create-home -s /bin/false node_exporter
sudo mkdir /etc/node_exporter
sudo mkdir /var/lib/node_exporter
sudo chown prometheus:prometheus /etc/node_exporter
sudo chown prometheus:prometheus /var/lib/node_exporter
sudo wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
sudo tar xvf node_exporter-0.18.1.linux-amd64.tar.gz
sudo mkdir -p /var/lib/prometheus/node_exporter
sudo mv node_exporter-0.18.1.linux-amd64/* /var/lib/prometheus/node_exporter
sudo chown -R prometheus:prometheus /var/lib/prometheus/node_exporter/
cat << EOF > /usr/lib/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/var/lib/prometheus/node_exporter/node_exporter

[Install]
WantedBy=default.target
EOF
sudo systemctl enable --now node_exporter.service
sudo firewall-cmd --permanent --add-port=9100/tcp
cat << EOF >> /etc/prometheus/prometheus.yml 
  - job_name: 'node_exporter'
    static_configs:
    - targets: ['0.0.0.0:9100']
EOF
sudo systemctl restart prometheus.service