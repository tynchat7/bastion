Hello, Congrats, You were able to configure and deploy bastion host.
Please use bellow information to access to the bastion host. 

Author: Farkhod Sadykov sadykovfarkhod@gmail.com

Deployment information
1. Username: <${username}>
2. Disk size: <${disk_size}>
3. Shared Disk size: <${shared_disk_size}>
4. Google Zone: <${zone}>
5. AMI ID: <${ami_id}>
6. Instance IP: <${bastion_host_ip}>


To login into bastion host use following command
ssh ${username}@${bastion_host_ip} 


If you found any issues please report to the blow link
https://github.com/fuchicorp/common_tools/issues