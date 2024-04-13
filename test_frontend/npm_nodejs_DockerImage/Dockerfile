# use ubuntu focal as base image
FROM ubuntu:focal AS nodejs_npm

# set user as root
USER root

# update and upgrade packages
RUN apt update 
RUN apt upgrade -y

# install curl to run set up script
RUN apt install curl -y

# set default shell (login as root && launch an INTERACTIVE SHELL)
SHELL ["/bin/bash", "--login", "-i", "-c"]

# run installation script and source .bashrc
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
RUN source /root/.bashrc

# install node && npm
RUN nvm install 16.15.1
RUN nvm use 16.15.1
RUN npm install -g npm@8.11.0

# return shell to non-interactive mode to stop docker's yelling
SHELL ["/bin/bash", "--login", "-c"]


