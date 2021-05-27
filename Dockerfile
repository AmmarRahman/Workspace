#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM phusion/baseimage:master



ARG PUID=1000
ARG PGID=1000
ARG USERNAME=Default
ENV USERNAME=${USERNAME}
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
WORKDIR /home/$USERNAME
#####################################
# Enable running as other users:
#####################################
RUN groupadd -g ${PGID} ${USERNAME} && \
    useradd -u ${PUID} -g ${USERNAME} -m ${USERNAME} -G docker_env && \
    usermod -p "*" ${USERNAME} -s /bin/zsh

#
#--------------------------------------------------------------------------
# Software's Installation
#--------------------------------------------------------------------------
#

#####################################
# Basic Tools:
#####################################
RUN apt-get install -y git


#####################################
# Javascript :
#####################################
# Install Node
USER root
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs

#####################################
# Network Tools:
#####################################
RUN apt-get install -y iputils-ping netcat


#####################################
# AWS CLI:
#####################################
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -r ./aws



#####################################
# Making things prettier:
#####################################
# Install Oh My Zsh
USER root
RUN apt-get install -y wget fonts-powerline zsh autojump

USER ${USERNAME}
ENV TERM xterm
ENV ZSH_THEME agnoster
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN echo "[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'" >> ~/.zshrc || echo "Using existing .zshrc"

USER root