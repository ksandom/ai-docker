# Use a base image with CUDA + Python support
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git \
      wget \
      python3 \
      python3-pip \
      ffmpeg \
      libgl1 \
      libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/stable-diffusion-webui

# Clone the AUTOMATIC1111 webui repo
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui . \
    && pip3 install --upgrade pip wheel

# (Optional) lock versions of conflicting dependencies
# e.g. if ?fastapi? or ?pytorch_lightning? need pinning
# RUN sed -i '/fastapi/c\fastapi==0.90.1' requirements.txt \
#     && sed -i '/pytorch_lightning/c\pytorch_lightning==1.6.5' requirements.txt \
#     && echo 'timm' >> requirements.txt

# Install python dependencies
RUN pip3 install -r requirements.txt

# Expose the default port
EXPOSE 7860

# Default command: run launch script with some useful flags
CMD ["python3", "launch.py", "--listen", "--port", "7860", "--api", "--enable-insecure-extension-access"]
