FROM rocm/pytorch:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    git python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user && chmod 0440 /etc/sudoers.d/user
USER ubuntu

ENV bump=1

ADD inside-install /usr/bin
ADD inside-tools /inside-tools

WORKDIR /workspace

RUN /usr/bin/inside-install
