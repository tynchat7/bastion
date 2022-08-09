variable "instance_name" {
  default     = "bastion-fuchicorp"
  description = "- (Optional) Give an any name on bastion host"
}

variable "deployment_name" {
  default     = "bastion-fuchicorp"
  description = "- (Optional) The actual deployment name"
}

variable "deployment_environment" {
  default     = "tools"
  description = "- (Optional) The deployment environment"
}

variable "vpc_network" {
  default     = "google_compute_network"
  description = "- (Optional) An optional description of this resource. The resource must be recreated to modify this field"
}

variable "google_compute_firewall" {
  default     = "test-firewall"
  description = "- (Optional) An optional description of this resource. The resource must be recreated to modify this field"

  # description = "name - (Required) Name of the resource. Provided by the client when the resource is created.
}

variable "google_project_id" {
  default     = "fuchicorp-project-256020"
  description = "- (Optional) That is gonna be used for our particular project ID in GCP"
}

variable "google_domain_name" {
  default     = "fuchicorp.com"
  description = "- (Optional) The Domain Name"
}

variable "google_credentials" {
  default     = "~/google-credentials.json"
  description = "- (Required) Path of a file containing the credential JSON"
}

variable "google_bucket_name" {
  default     = "yourbucketname"
  description = "- (Required) Name of the bucket on GCP"
}

variable "zone" {
  default     = "us-central1-a"
  description = "- (Optional) Here we are specified in which A-Z suppose to be our bastion host"
}

variable "machine_type" {
  default     = "n1-standard-1"
  description = "- (Optional) VM instance, including the system memory size, virtual CPU, and persistent disk limits"
}

variable "git_common_token" {
  description = "- (Requirements) Will use for listing members from organization and onboarind to bastion host."
}

variable "ami_id" {
  description = "Packer Build in common lib is required"
}

variable "gce_ssh_user" {
  default     = "root"
  description = "- (Optional) That's will use for entry via ssh to the bastion host"
}

variable "gce_ssh_pub_key_file" {
  default     = "~/.ssh/id_rsa.pub"
  description = "- (Optional) Here is will be a choosing an access method to bastion host"
}

variable "instance_disk_zie" {
  default     = "40"
  description = "- (Optional) The disk size for the bastion host <example 30 40 50 >"
}

variable "user_shared_disk_size" {
  default     = "60"
  description = "- (Optional) The disk size for fuchicorp users shared disk!å"
}

variable "allow_stopping_for_update" {
  default     = "false"
  description = "- (Optional) To allow bastion to be stoped and upgraded"
}

variable "firewall_rules" {
  type = list

  default = [
    {
      name        = "five-thousand-port"
      port        = "5000"
      cidr        = "0.0.0.0/0"
      description = "Allowing 5000 port to the bastion host."
    },
    {
      name        = "eighty-eighty-port"
      port        = "8080"
      cidr        = "0.0.0.0/0"
      description = "Allowing 8080 port to the bastion host."
    },
    {
      name        = "ninty-ninty-port"
      port        = "9090"
      cidr        = "10.128.0.0/9"
      description = "Allowing 9090 port to the bastion host."
    },
  ]

  description = "- (Optional) List of Map to manage all firewall rules."
}
