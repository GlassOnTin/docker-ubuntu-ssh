# Docker Ubuntu SSH for ChatGPT Plugin Development

This repository contains a Docker setup tailored for developing ChatGPT plugins. It includes a development environment with various utilities, programming languages, and libraries.

## Features

- **Ubuntu Base**: Latest version of Ubuntu as the base image.
- **Development Tools**: Pre-installed Node.js, Python 3, and their respective package managers.
- **SSH Access**: SSH server setup for both root and a non-root user (`devuser`).
- **Customizable**: Root password and ports are configurable via build arguments and environment variables.
- **Automated Deployment**: One-click deployment to Render via a button in this README.

## Deploy to Render

<a href="https://render.com/deploy?repo=https://github.com/GlassOnTin/docker-ubuntu-ssh/tree/master">
<img src="https://render.com/images/deploy-to-render-button.svg" alt="Deploy to Render" />
</a>

## Usage

### Build the Docker Image

Replace `your_root_password` with the desired root password.

```bash
docker build --build-arg ROOT_PASSWORD=your_root_password -t your_image_name .
