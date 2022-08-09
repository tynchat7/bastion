#!/bin/bash
if [ ! $(which zsh 2>/dev/null) ] 2>/dev/null;
then
    sudo yum install zsh -y
    sudo  wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    yes | sudo ZSH="/usr/share/oh-my-zsh" sh install.sh

    sudo chmod +x  /root/.zshrc
    sudo mv /root/.zshrc /usr/share/oh-my-zsh/zshrc

    sudo sed -i 's/robbyrussell/bira/g' /usr/share/oh-my-zsh/zshrc
    sudo sed -i 's|# export PATH=$HOME/bin:/usr/local/bin:$PATH|export PATH=/usr/share/bin:/usr/local/bin:$PATH|g' /usr/share/oh-my-zsh/zshrc

    sudo mv ~/.bash_profile ~/.bash_profile.old  
    (echo :; echo exec /bin/zsh -il) > ~/.bash_profile
    sudo sed -i 's|# .bashrc|exec zsh|g' ~/.bashrc
    yes| sudo cp /usr/share/oh-my-zsh/zshrc  /etc/skel/.zshrc 
    sudo sed -i 's|SHELL=/bin/bash|SHELL=/bin/zsh|g' /etc/default/useradd


    getent passwd | while IFS=: read -r name password uid gid gecos home shell; do
        # only users that own their home directory
        if [ -d "$home" ] && [ "$(stat -c %u "$home")" = "$uid" ]; then
            # only users that have a shell, and a shell is not equal to /bin/false or /usr/sbin/nologin
            if [ ! -z "$shell" ] && [ "$shell" != "/bin/false" ] && [ "$shell" != "/usr/sbin/nologin" ]; then
                echo "$name" >> user_list.txt
            fi
        fi
    done
    sudo echo 'export PATH=$PATH:/opt/sonar-scanner/bin' >> /etc/profile
    sudo echo 'export PATH=$PATH:/common_scripts/bastion-scripts/bin' >> /etc/profile
fi