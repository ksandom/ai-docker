# Search here: https://hub.docker.com/r/pytorch/pytorch/tags?name=runtime
#FROM pytorch/pytorch:2.4.1-cuda12.1-cudnn8-runtime
#FROM pytorch/pytorch:2.8.0-cuda12.9-cudnn9-runtime
FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# sys deps
RUN apt-get update && apt-get install -y --no-install-recommends \
      git ffmpeg libgl1 libglib2.0-0 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/stable-diffusion-webui
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui . \
 && python3 -m pip install --upgrade pip setuptools wheel

RUN python3 -m pip install --no-cache-dir \
    importlib-metadata \
    typing-extensions

ENV COMMANDLINE_ARGS="--listen --port 7860 --api --no-half --precision full --skip-torch-cuda-test"

EXPOSE 7860

CMD ["bash","-lc","python3 launch.py $COMMANDLINE_ARGS"]
