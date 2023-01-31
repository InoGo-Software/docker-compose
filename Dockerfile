FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam

RUN apt-get update

RUN apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update

# Install docker/docker-compose
RUN VERSION_STRING=5:20.10.13~3-0~ubuntu-focal && apt-get install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-compose-plugin=2.15.1-1~ubuntu.20.04~focal -y

RUN apt-get install make git sshpass -y

# Install npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install nodejs

RUN npm isntall -g yarn

# Alias the docker-compose command to docker compose.
RUN echo 'docker compose "$@"' | tee /bin/docker-compose
RUN chmod +x /bin/docker-compose