#!/bin/bash
nameserver=("8.8.8.8" "8.8.4.4")
srv="srv.smartiptv.pt"

Sudo_Test=$(set)
Check() {

curl -o bash-draw2.sh https://github.com/onixsat/install/edit/main/bash-draw.sh
curl -o bash-menu2.sh https://github.com/onixsat/install/edit/main/bash-menu.sh

	. "bash-menu.sh"
	
	load(){
		if [[ $EUID -ne 0 ]]; then
		  echo "ERROR: This script must be run as root" 2>&1
		  exit 1
		fi

		if [ "$BASH_SOURCE" = "" ]; then
			/bin/bash "$0"
			exit 0
		fi
	}
	#load
	
	echo -e "\nChecking root privileges..."
	if echo "$Sudo_Test" | grep SUDO >/dev/null; then
		echo -e "\nYou are using SUDO , please run as root user...\n"
		exit
  	fi

	if [[ $(id -u) != 0 ]] >/dev/null; then
		echo -e "\nYou must run on root user to install CyberPanel...\n"
		echo -e "or run following command: (do NOT miss the quotes)"
		echo -e "\e[31msudo su -c \"sh <(curl https://cyberpanel.sh || wget -O - https://cyberpanel.sh)\"\e[39m"
		exit 1
	else
  		echo -e "\nYou are runing as root...\n"
	fi
}
Check


function continua(){
echo -n "Press enter to continue ... "
}
function linearSearch (){
filename="${1}" # $1 represent first argument




 if [ -e "$filename" ]; then 
    content=$(cat "$filename") 
    echo -e "$content" 
	return 0
else 
    echo "File not found: $filename" 
fi
    return 1
}
function outer() {

	Pre() {
		Debug_Log2 "Setting"
		Line_Number=$(grep -n "127.0.0.1" /etc/hosts | cut -d: -f 1)
		My_Hostname=$(hostname)

		if [[ -n $Line_Number ]]; then
		  for Line_Number2 in $Line_Number ; do
			String=$(sed "${Line_Number2}q;d" /etc/hosts)
			if [[ $String != *"$My_Hostname"* ]]; then
			  New_String="$String $My_Hostname"
			  sed -i "${Line_Number2}s/.*/${New_String}/" /etc/hosts
			fi
		  done
		else
		  echo "127.0.0.1 $My_Hostname " >>/etc/hosts
		fi

	}
	
	Check_Root() {
		while true; do
		  echo -e "\nHostnames:"
		  echo "1. Editar"
		  echo "2. $srv"

		  read -p "Enter your choice (1 or 2): " choice

		  case $choice in
			1)
			  echo "Escreva"
			  read -p "New Hostname: " srv
			  continua=true
			  break
			  ;;
			2)
		#  echo -e "New Hostname: $srv"
			  continua=true
			  break
			  ;;
			*)
			  echo -e "Invalid choice. Please choose 1 or 2."
			  ;;
		  esac
		done

	}
    inner() {

hn=$1 srv=$2 
/bin/sed -i -- 's/'"$hn"'/'"$srv"'/g' /etc/hosts
/bin/sed -i -- 's/'"$hn"'/'"$srv"'/g' /etc/hostname
hostnamectl set-hostname $srv
hostnamectl set-hostname "crowncloud production server" --pretty
printf "Changing Hostname: "
linearSearch "/etc/hostname"
printf "Changing Hosts:\n"
linearSearch "/etc/hosts"

cp /etc/resolv.conf /etc/resolv.conf_bak
rm -f /etc/resolv.conf


if [ -n "$nameserver" ]; then
  echo -e "nameserver ${nameserver[0]}" > /etc/resolv.conf
  echo -e "nameserver ${nameserver[1]}" >> /etc/resolv.conf
else
  echo -e "nameserver 1.1.1.1" > /etc/resolv.conf
  echo -e "nameserver 8.8.8.8" >> /etc/resolv.conf
fi

	printf "\nNovo /etc/resolv.conf:\n"
	  linearSearch "/etc/resolv.conf"
	
    }

	hn=$(/bin/hostname)
	hn=$(hostname -f)
	hn="vps-98e038c0.vps.ovh.net"
	echo Current Hostname: $hn

	Check_Root
	inner $hn $srv
	
	if [ "$continua" = true ]; then
    echo -e "The Boolean is true\n\n"

	  else
	  printf "lol\n\n"
	  fi
}

action1() {
    echo "Update password!"#echo "Password2024" | pw usermod -n root -h 0
    echo 'Password2024' | passwd --stdin root
	continua
    read response
    return 1
}
action2() {
    echo "Update!"
	sudo yum update -y ;
	sudo yum upgrade -y ;
	dnf install wget curl -y ;
	dnf install php-dev php-pecl -y ;
	sudo yum install openssh-clients -y ;
    continua
    read response

    return 1
}
action3() {
    echo "Configuração!"
	outer $hn $srv
    continua
    read response
    return 1
}
action4() {
	echo "Instal CyberPanel!"
	#curl --silent -o cyberpanel.sh "https://cyberpanel.sh/?dl&$SERVER_OS" 2>/dev/null
	#chmod +x cyberpanel.sh
	#./cyberpanel.sh $@
	sh <(curl https://cyberpanel.net/install.sh || wget -O - https://cyberpanel.net/install.sh)
	sudo firewall-cmd --zone=public --permanent --add-port=7080/tcp
	sudo firewall-cmd --zone=public --permanent --add-port=8090/tcp
	sudo firewall-cmd --reload
	continua
    read response
    return 1
}

action5() {
	echo "Menu!"
    setupBitMenu
    menuInit
    menuLoop
	
    echo -e  "Result: $bitness."

    continua
    read response
    return 1
}
actionX() {
    return 0
}
setupBitMenu() {

	bit32() {
		bitness="32"
		return 0
	}
	bit64() {
		bitness="64"
		return 0
	}
	bitHelp() {
		echo "Bitness Help"
		echo -n "Press Enter to return to menu"
		read response

		return 1
	}

    menuItems=(
        "1. 64-Bit"
        "2. 32-Bit"
        "3. Help  "
        "4. Back  "
    )

    menuActions=(
        bit64
        bit32
        bitHelp
        actionX
    )

    menuTitle=" Select Game Bitness"
    menuFooter=" "
    menuWidth=40
    menuLeft=25
    menuHighlight=$DRAW_COL_YELLOW
}


action6() {
	echo -e "Outro!"
	printf "%s" "Please confirm to proceed: [Y/n]: "
	read TMP_YN
	if [[ $TMP_YN == "Y" ]] || [[ $TMP_YN == "y" ]] ; then 
		echo "texto1..."
	else 
		echo -e "Please enter Y or n."
		exit 
	fi 
}

menuItems=(
    "1. Password"
    "2. Update"
    "3. Configuração"
    "4. Instal CyberPanel"
    "5. Menu"
	"6. Outro"
    "Q. Exit  "
)
menuActions=(
    action1
    action2
    action3
    action4
    action5
	action6
    actionX
)

menuTitle=" Demo of bash-menu"
menuFooter=" Enter=Select, Navigate via Up/Down/First number/letter"
menuWidth=60
menuLeft=25
menuHighlight=$DRAW_COL_YELLOW

menuInit
menuLoop

exit 0
