FROM ubuntu:latest
LABEL maintainer="Your Name <your.email@example.com>"

# Update package lists and upgrade packages
RUN apt-get update -y && apt-get upgrade -y

# Install basic packages
RUN apt-get install -y sudo curl git-core gnupg 

# Install development tools
RUN apt-get install -y linuxbrew-wrapper locales nodejs zsh wget nano python3 python3-pip openssh-server

# Install Python packages
RUN pip3 install docker Flask celery pyjwt

# Install Node.js packages
RUN npm install -g express socket.io winston

# Configure locale and add user
RUN locale-gen en_US.UTF-8 && \
    adduser --quiet --disabled-password --shell /bin/zsh --home /home/devuser --gecos "User" devuser && \
    echo "devuser:p@ssword1" | chpasswd &&  usermod -aG sudo devuser

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
