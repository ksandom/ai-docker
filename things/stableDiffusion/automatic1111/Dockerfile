# Ubuntu 22.04 + CUDA 11.8 runtime (driver can run cu113 user-space fine)
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    CONDA_DIR=/opt/conda \
    PATH=/opt/conda/bin:$PATH

# Core deps + tools (execstack/binutils optional; helpful for checking ELF flags)
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl wget git ffmpeg \
      libgl1 libglib2.0-0 \
      bzip2 bash tini \
      execstack binutils \
 && rm -rf /var/lib/apt/lists/*

# ------- Miniconda (for a clean Python 3.9 env) -------
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/mc.sh \
 && bash /tmp/mc.sh -b -p "$CONDA_DIR" \
 && rm -f /tmp/mc.sh \
 && conda config --system --set auto_update_conda false \
 && conda clean -afy

# Accept terms.
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r




# # Create env with Python 3.9 (needed for torch==1.10.2 wheels)
# RUN conda create -y -n sd python=3.9 && conda clean -afy
#
# # Maxwell-friendly Torch stack (SM_52) ? cu113 wheels
# RUN conda run -n sd python -m pip install --upgrade pip setuptools wheel && \
#     conda run -n sd python -m pip install --no-cache-dir \
#       torch==1.10.2+cu113 torchvision==0.11.3+cu113 \
#       --extra-index-url https://download.pytorch.org/whl/cu113
#
# # (Optional) verify no exec-stack on torch libs
# # RUN conda run -n sd python - <<'PY'
# # import os, glob, site, subprocess
# # for p in site.getsitepackages()+[site.getusersitepackages()]:
# #     d=os.path.join(p,"torch","lib")
# #     if os.path.isdir(d):
# #         for so in glob.glob(os.path.join(d,"*.so")):
# #             print(subprocess.run(["execstack","-q",so], capture_output=True, text=True).stdout.strip())
# # PY
#
# # A1111 deps (allow optional pins to fail quietly)
# RUN conda run -n sd python -m pip install --no-cache-dir -r requirements_versions.txt || true && \
#     conda run -n sd python -m pip install --no-cache-dir -r requirements.txt || true && \
#     conda run -n sd python -m pip install --no-cache-dir typing-extensions importlib-metadata
#
# # --- AUTOMATIC1111 ---
# WORKDIR /opt/stable-diffusion-webui
# # full clone (no --depth) so we can import launch_utils and read the pinned SHAs
# RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui .
#
# # Pre-seed the exact commits the WebUI expects by reading launch_utils.py
# RUN python - <<'PY'
# import os, subprocess, importlib.util
# from pathlib import Path
#
# root = Path("/opt/stable-diffusion-webui")
# repos = root / "repositories"
# repos.mkdir(exist_ok=True)
#
# # import modules/launch_utils.py from the just-cloned webui
# spec = importlib.util.spec_from_file_location(
#     "launch_utils", root / "modules" / "launch_utils.py"
# )
# lu = importlib.util.module_from_spec(spec)
# spec.loader.exec_module(lu)
#
# # Collect (name, url, commit) tuples from launch_utils if present
# targets = []
# def add(name_attr_repo, name_attr_sha, default_dirname):
#     url = getattr(lu, name_attr_repo, None)
#     sha = getattr(lu, name_attr_sha, None)
#     if url and sha:
#         targets.append((default_dirname, url, sha))
#
# add("stable_diffusion_repo", "stable_diffusion_commit_hash", "stable-diffusion-stability-ai")
# add("stable_diffusion_xl_repo", "stable_diffusion_xl_commit_hash", "generative-models")
# add("k_diffusion_repo", "k_diffusion_commit_hash", "k-diffusion")
# add("blip_repo", "blip_commit_hash", "BLIP")
#
# def run(cmd, cwd=None):
#     print("+", cmd)
#     subprocess.run(cmd, shell=True, check=True, cwd=cwd)
#
# for dirname, url, sha in targets:
#     path = repos / dirname
#     if not path.exists():
#         run(f'git clone "{url}" "{path}"')
#     # ensure full history so checkout of arbitrary SHA always works
#     run("git fetch --all --tags", cwd=path)
#     run(f"git checkout {sha}", cwd=path)
#
# print("Seeded repos:", [d for d,_,_ in targets])
# PY
#
# # (Optional) other repos that aren't pinned can be shallow to save space
# RUN git clone --depth 1 https://github.com/AUTOMATIC1111/stable-diffusion-webui-assets.git repositories/stable-diffusion-webui-assets || true
#
# # Maxwell-safe defaults: no FP16; skip torch CUDA self-test
# ENV COMMANDLINE_ARGS="--listen --port 7860 --api --no-half --precision full --skip-torch-cuda-test"
#
# EXPOSE 7860
#
# # Use tini as PID 1; launch via the conda env
# ENTRYPOINT ["/usr/bin/tini","--"]
# CMD ["bash","-lc","exec conda run -n sd --no-capture-output python -u launch.py ${COMMANDLINE_ARGS}"]

ENTRYPOINT /bin/bash

