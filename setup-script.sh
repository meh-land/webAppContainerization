#!/bin/bash

# creating environment variables (necessary when .env is edited)
user_name='melonlord'
db_host='database' # same as mysql service name
user_pass='dudetrustme'

# check linux distro to install dependency
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
 	local DISTRIB=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
	if [[ $DISTRIB = "Arch"* ]]; then
	
		# use pacman
		sudo pacman -Syu -y
	    sudo pacman -S git docker docker-compose -y	
		sudo pacman -S bash-completion -y # this one is simply for convenience

      	elif [[ ${DISTRIB} = "Ubuntu"* ]]; then
    	
		# use apt
		sudo apt-get update
		sudo apt-get install ca-certificates curl -y
		sudo install -m 0755 -d /etc/apt/keyrings 
		sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
		sudo chmod a+r /etc/apt/keyrings/docker.asc
		echo \
  		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		sudo apt-get update
		sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  	
	elif [[ ${DISTRIB} = "Debian"* ]]; then
    	
		# use apt
		sudo apt-get update
		sudo apt-get install ca-certificates curl -y
		sudo install -m 0755 -d /etc/apt/keyrings
		sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
		sudo chmod a+r /etc/apt/keyrings/docker.asc

		# Add the repository to Apt sources:
		echo \
  		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		sudo apt-get update
		sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  	
	fi
fi

# start docker daemon && launch it on startup using systemd (assuming your init system is systemd)
sudo systemctl start docker.service
sudo systemctl enable docker.service

# add user to docker group
sudo usermod -aG docker $USER

# clone frontend and backend repos in container folder
git clone https://github.com/meh-land/GP_laravel # backend
git clone https://github.com/meh-land/web_App # frontend

# create .env file in GP_laravel
cd GP_laravel
cp .env.example .env

# fill empty environment variables
sed -i '/DB_USERNAME=/c\DB_USERNAME='${user_name}'' .env
sed -i '/DB_PASSWORD=/c\DB_PASSWORD='${user_pass}'' .env

# replace DB_HOST with database (mysql service name)
sed -i '/DB_HOST=127.0.0.1/c\DB_HOST='${db_host}'' .env

# return to webAppContainerization directory
cd ..














































