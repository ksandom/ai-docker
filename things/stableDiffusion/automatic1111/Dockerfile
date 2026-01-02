FROM rocm/pytorch:latest

ENV DEBIAN_FRONTEND=noninteractive
# System build deps for common Python packages + git + curl for rustup
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates \
    python3.12 python3.12-venv python3-pip \
    build-essential pkg-config cmake \
    libssl-dev libffi-dev \
    zlib1g-dev libjpeg-dev libpng-dev \
    libopenblas-dev \
    && rm -rf /var/lib/apt/lists/*

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user && chmod 0440 /etc/sudoers.d/user
# Create workspace and ensure ubuntu can write to it
RUN mkdir -p /workspace && chown -R ubuntu:ubuntu /workspace

ENV bump=1

USER ubuntu

# Install a modern Rust toolchain (stable) so tokenizers can build
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/home/ubuntu/.cargo/bin:${PATH}"

# Optional: show versions in build log (useful for debugging)
RUN rustc --version && cargo --version && python3.12 --version

# ADD inside-install /usr/bin
ADD inside-tools /inside-tools-buildTime
RUN sudo /inside-tools-buildTime/move-external

WORKDIR /workspace
