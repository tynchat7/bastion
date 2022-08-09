#!/bin/bash
set -e 
declare -a ListOfPackages=("packer" "terraform" "kubectl" "docker-compose" "docker" "helm" "python3" "tree" "curl" "wget" "java" "groovy" "waypoint" "nslookup" "aws" "zsh" "telnet" "istioctl" "vault" "trivy") 
for val in ${ListOfPackages[@]}; do
    if which $val &> /dev/null; then 
        echo "$val is installed"
    else
        echo "$val is not installed in the basiton host!"
        sleep 5
        exit 1
    fi 
done
