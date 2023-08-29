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
COPY ./healthCheck.py /app/
COPY ./requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r /app/requirements.txt

# Switch to non-root user
USER appuser

# Expose ports
EXPOSE 22 3000 4000

# Start SSH daemon and run health check and app
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
CMD ["sh", "-c", "python /app/healthCheck.py & python /app/app.py"]
