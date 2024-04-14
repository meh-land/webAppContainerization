# use ubuntu focal as base image
FROM ubuntu:focal AS nodejs_npm

# set user as root
USER root

# update and upgrade packages
RUN apt update 
RUN apt upgrade -y

# install curl to run set up script
RUN apt install -y curl git vim

# set default shell (login as root && launch an INTERACTIVE SHELL)
SHELL ["/bin/bash", "--login", "-i", "-c"]

# run installation script and source .bashrc
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
RUN source /root/.bashrc

# install node && npm
RUN nvm install 16.15.1
RUN nvm use 16.15.1
RUN npm install -g npm@8.11.0

# copy web_App to container
RUN mkdir -p /frontend
WORKDIR /frontend
COPY ./web_App .


# have to rerun npm install
WORKDIR /frontend/web_App
RUN npm install

# copy entrypoint script to container
COPY ./entrypoint/entrypoint-frontend.sh .

# return shell to non-interactive mode to stop docker's yelling
SHELL ["/bin/bash", "--login", "-c"]

# entrypoint script to start npm in the background
ENTRYPOINT [ "/bin/bash", "entrypoint-frontend.sh"]


