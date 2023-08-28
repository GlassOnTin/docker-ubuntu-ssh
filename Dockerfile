FROM ubuntu:latest
LABEL maintainer="Your Name <your.email@example.com>"

# Accept a build argument for the root password
ARG ROOT_PASSWORD

# Update the system and install packages
RUN apt-get update && \
    apt-get install -y sudo curl git-core gnupg linuxbrew-wrapper locales nodejs zsh wget nano nodejs npm fonts-powerline python3 python3-pip openssh-server && \
    pip3 install docker Flask celery pyjwt && \
    npm install -g express socket.io winston && \
    locale-gen en_US.UTF-8 && \
    adduser --quiet --disabled-password --shell /bin/zsh --home /home/devuser --gecos "User" devuser && \
    echo "devuser:p@ssword1" | chpasswd &&  usermod -aG sudo devuser

# Set the root password using the build argument
RUN echo "root:${ROOT_PASSWORD}" | chpasswd

# Set up SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Add custom scripts
ADD scripts/installthemes.sh /home/devuser/installthemes.sh

# Switch to devuser
USER devuser

# Set environment variables
ENV TERM xterm
ENV ZSH_THEME agnoster

# Expose SSH port and a custom port for our API
EXPOSE 22 3000

# Run SSH and Zsh
CMD ["/usr/sbin/sshd", "-D"]
