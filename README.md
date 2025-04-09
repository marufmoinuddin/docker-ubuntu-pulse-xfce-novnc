### Building a Docker Image for Ubuntu 22.04 with PulseAudio and noVNC
This repository contains a Dockerfile to build an image of Ubuntu 22.04 with PulseAudio and noVNC support. The image is designed to run a lightweight desktop environment and provide remote access via VNC and web browser.
### Prerequisites
- Docker installed on your machine.
- Basic knowledge of Docker commands.
### Building the Docker Image
To build the Docker image, navigate to the directory containing the Dockerfile and run the following command:

```bash
docker build -t ubuntu-pulse-xfce-novnc .
```
### Running the Docker Container
After building the image, you can run a container using the following command:

```bash
docker run --privileged --shm-size 1g -d -p 5900:5900/tcp -p 8080:10000 -e VNC_PASSWD=password -e PORT=10000 -e AUDIO_PORT=1699 -e WEBSOCKIFY_PORT=6900 -e VNC_PORT=5900 -e SCREEN_WIDTH=1024 -e SCREEN_HEIGHT=768 -e SCREEN_DEPTH=24 ubuntu-pulse-xfce-novnc
```