#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOSTNAME=$(hostname -f)
PASSV_PORT="50000:50100";
PASSV_MIN=$(echo $PASSV_PORT | cut -d':' -f1)
PASSV_MAX=$(echo $PASSV_PORT | cut -d':' -f2)
ISVPS=$(((dmidecode -t system 2>/dev/null | grep "Manufacturer" | grep -i 'VMware\|KVM\|Bochs\|Virtual\|HVM' > /dev/null) || [ -f /proc/vz/veinfo ]) && echo "SI" || echo "NO")

echo "########  #### ##    ##    ###    ########     #### ########"
echo "##     ##  ##   ##  ##    ## ##   ##     ##     ##     ##"    
echo "##     ##  ##    ####    ##   ##  ##     ##     ##     ##"   
echo "##     ##  ##     ##    ##     ## ########      ##     ##"   
echo "##     ##  ##     ##    ######### ##   ##       ##     ##"   
echo "##     ##  ##     ##    ##     ## ##    ##      ##     ##"   
echo "########  ####    ##    ##     ## ##     ##    ####    ##"   

echo ""
echo "             ####################### Panel Configurator #######################              "
echo ""
echo ""

if [ ! -f /etc/redhat-release ]; then
	echo "CentOS was not detected. Aborting"
	exit 0
fi

#echo "This script installs and pre-configures cPanel (CTRL + C to cancel)"
#sleep 10

#echo "####### SETTING CENTOS #######"
#wget https://raw.githubusercontent.com/diyarit/Centos-Config/master/configure_centos.sh -O "$CWD/configure_centos.sh" && bash "$CWD/configure_centos.sh"

#echo "####### CPANEL PRE-CONFIGURATION ##########"
#echo "Disabling yum-cron..."
#yum erase yum-cron -y

Sudo_Test=$(set)
Check_Root() {
	echo -e "\nChecking root privileges..."
  if echo "$Sudo_Test" | grep SUDO >/dev/null; then
    echo -e "\nYou are using SUDO , please run as root user...\n"
    echo -e "\nIf you don't have direct access to root user, please run \e[31msudo su -\e[39m command (do NOT miss the \e[31m-\e[39m at end or it will fail) and then run installation command again."
    exit
  fi

  if [[ $(id -u) != 0 ]] >/dev/null; then
    echo -e "\nYou must run on root user to install CyberPanel...\n"
    echo -e "or run following command: (do NOT miss the quotes)"
   # echo -e "\e[31msudo su -c \"sh <(curl https://cyberpanel.sh || wget -O - https://cyberpanel.sh)\"\e[39m"
    exit 1
  else
    echo -e "\nYou are runing as root...\n"
  fi
}
Check_Root()

#sudo su -
#passwd
#dnf install wget curl -y
#dnf install php-dev php-pecl -y
#yum -y install openssh-clients

#sh <(curl https://cyberpanel.net/install.sh || wget -O - https://cyberpanel.net/install.sh)
#sudo firewall-cmd --zone=public --permanent --add-port=7080/tcp
#sudo firewall-cmd --zone=public --permanent --add-port=8090/tcp
#sudo firewall-cmd --reload

history -c
echo "" > /root/.bash_history

echo "#### ¡Finished!. If you are going to restart do it in 10 minutes because you're be updating MySQL ####"
