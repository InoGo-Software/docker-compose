FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam

RUN apt-get update

RUN apt-get install \
    ca-certificates \
    curl \
    gnupg \
    jq \
    python3-pip \
    openssh-client \
    git \
    sshpass \
    make \
    default-jre \
    lsb-release -y

RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update

RUN apt-cache madison docker-ce | awk '{ print $3 }'

# Install docker/docker-compose
RUN VERSION_STRING=5:25.0.5-1~ubuntu.22.04~jammy && apt-get install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-compose-plugin=2.25.0-1~ubuntu.22.04~jammy -y

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install npm
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install nodejs
RUN npm install -g yarn

# Download and install Go
RUN curl -OL https://golang.org/dl/go1.25.0.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz && \
    rm go1.25.0.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Alias the docker-compose command to docker compose.
RUN echo 'docker compose "$@"' | tee /bin/docker-compose
RUN chmod +x /bin/docker-compose

# AWS CLI
RUN pip3 install awscli
