rm -rf /home/centos-cloud
sudo mkfs.ext4 /dev/sdb
useradd "$1" -d "/home/$1" --comment "$2"
sudo mount -o discard,defaults /dev/sdb /home
source /root/.zshrc && cd /common_scripts/bastion-scripts/ && python3 sync-users.py #onboard everyone 


if ! echo "$(blkid /dev/sdb)" | grep  'ext4'; then
  mkfs.ext4 /dev/sdb -F 
fi

if [ ! -d '/fuchicorp' ]; then
    mkdir '/fuchicorp'
    mkdir '/fuchicorp/home' 
    chmod 755 '/fuchicorp/home' 
fi
mount -o discard,defaults '/dev/sdb' '/fuchicorp'



useradd "fsadykov1" -d "/fuchicorp/home/fsadykov1" --comment "example" -m --shell /bin/zsh

# echo 'export GIT_TOKEN="${var.git_common_token}"' >> /root/.zshrc 
# for i in $(cat /etc/passwd | grep fuchicorp-scripts  | awk -F ':' '{print $1}') do; userdel -r $i; done