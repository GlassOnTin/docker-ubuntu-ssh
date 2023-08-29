# Use latest Alpine version
FROM alpine:latest

# Install packages in one RUN command to reduce layers
RUN apk add --update --no-cache \
    python3 \
    py3-pip \
    openssh \
    nodejs \
    npm && \
    npm install -g express socket.io winston && \
    addgroup -S appgroup && \
    adduser -S appuser -G appgroup && \
    sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config

# Copy health check script and requirements
COPY ./health_check.py /app/
COPY ./requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r /app/requirements.txt

# Switch to non-root user
USER appuser

# Expose ports
EXPOSE 22 3000 4000

# Run SSH daemon, health check, and app as a command
CMD ["sh", "-c", "/usr/sbin/sshd -D & python /app/healthCheck.py & python /app/app.py"]
